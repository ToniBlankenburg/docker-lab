#!/bin/sh
# Verifier-Prüfskript für Lab 00 (Dummy).
#
# Contract:
#   - Erfolg:   Stdout enthält "FLAG{<slug>}" + "✅ Lab NN gelöst. Gesamt: X / Y",
#               Exit 0, progress.json wird idempotent ergänzt.
#   - Misserfolg: Stderr enthält eine spoilerfreie Fehlermeldung, Exit 1,
#                 progress.json bleibt unverändert.
#   - Kaputte progress.json wird durch leeren Zustand ersetzt (Hinweis auf Stderr).
set -eu

LAB_NUMBER="${LAB_NUMBER:-00}"
LAB_SLUG="${LAB_SLUG:-dummy}"
LAB_TOTAL="${LAB_TOTAL:-1}"
TARGET_HOST="${TARGET_HOST:-target}"
TARGET_PORT="${TARGET_PORT:-80}"
PROGRESS_DIR="${PROGRESS_DIR:-/progress}"
PROGRESS_FILE="$PROGRESS_DIR/progress.json"
EMPTY_PROGRESS='{"version":1,"labs_solved":[]}'

mkdir -p "$PROGRESS_DIR"

# --- Fortschrittsdatei absichern -----------------------------------------
if [ ! -f "$PROGRESS_FILE" ]; then
  printf '%s\n' "$EMPTY_PROGRESS" > "$PROGRESS_FILE"
elif ! jq -e '.' "$PROGRESS_FILE" >/dev/null 2>&1; then
  echo "Hinweis: progress.json war beschädigt und wurde durch leeren Zustand ersetzt." >&2
  printf '%s\n' "$EMPTY_PROGRESS" > "$PROGRESS_FILE"
fi

# --- Ziel-Container abfragen (mit kurzem Retry-Fenster) ------------------
# --noproxy '*' erzwingt Direktverbindung, auch wenn Docker Desktop einen
# HTTP-Proxy in den Container injiziert (Corp-Umgebungen).
response=""
reachable=0
attempt=0
while [ "$attempt" -lt 15 ]; do
  if response=$(curl -sf --noproxy '*' --max-time 3 "http://${TARGET_HOST}:${TARGET_PORT}/" 2>/dev/null); then
    reachable=1
    break
  fi
  attempt=$((attempt + 1))
  sleep 1
done

if [ "$reachable" -ne 1 ]; then
  echo "Ziel-Container nicht auf Port ${TARGET_PORT} erreichbar." >&2
  exit 1
fi

if ! printf '%s' "$response" | grep -q 'SOLVED'; then
  echo "Ziel-Container erreichbar, aber Zielzustand noch nicht erfüllt." >&2
  exit 1
fi

# --- Fortschritt idempotent ergänzen -------------------------------------
now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
tmp=$(mktemp)
jq --arg lab "$LAB_NUMBER" --arg t "$now" '
  if ([.labs_solved[]?.lab] | index($lab)) then .
  else .labs_solved += [{lab: $lab, solved_at: $t}]
  end
' "$PROGRESS_FILE" > "$tmp"
mv "$tmp" "$PROGRESS_FILE"

solved=$(jq '.labs_solved | length' "$PROGRESS_FILE")

# --- Erfolgs-Ausgabe -----------------------------------------------------
echo "FLAG{${LAB_SLUG}-solved}"
echo "✅ Lab ${LAB_NUMBER} gelöst. Gesamt: ${solved} / ${LAB_TOTAL}"
