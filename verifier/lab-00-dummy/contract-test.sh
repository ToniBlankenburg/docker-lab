#!/usr/bin/env bash
# ============================================================================
# Generisches Verifier-Contract-Test-Harness.
#
# Kopiere diese Datei unverändert in einen neuen Verifier-Ordner. Alle
# lab-spezifischen Details leben in `fixtures/` und `check.sh`.
#
# Prüft pro Fixture (solved/unsolved) den vollständigen Verifier-Contract
# aus dem Spec:
#   - solved   → Exit 0, `FLAG{...}` und Status-Zeile im Stdout,
#                progress.json enthält den Eintrag; ein zweiter Lauf legt
#                keinen doppelten Eintrag an (Idempotenz); eine kaputte
#                progress.json wird durch leeren Zustand ersetzt.
#   - unsolved → Exit 1, spoilerfreie Fehlermeldung auf Stderr, keine Flag,
#                progress.json bleibt unverändert.
#
# Nutzung:
#   bash verifier/lab-NN-<slug>/contract-test.sh
#
# Umgebungs-Overrides (optional):
#   VERIFIER_IMAGE  — vollständiger Image-Tag, sonst lokal gebaut.
#   SKIP_BUILD=1    — Build überspringen (nutze vorhandenes Image).
# ============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR_NAME="$(basename "$SCRIPT_DIR")"        # z. B. lab-00-dummy
LAB_NUMBER_SUFFIX="${LAB_DIR_NAME#lab-}"         # 00-dummy
LAB_NUMBER="${LAB_NUMBER_SUFFIX%%-*}"            # 00
VERIFIER_IMAGE="${VERIFIER_IMAGE:-docker-schulung/verify-${LAB_DIR_NAME}:test}"

log()   { printf '\033[1;34m[%s]\033[0m %s\n' "$LAB_DIR_NAME" "$*"; }
ok()    { printf '\033[1;32m[%s OK]\033[0m %s\n' "$LAB_DIR_NAME" "$*"; }
fail()  { printf '\033[1;31m[%s FAIL]\033[0m %s\n' "$LAB_DIR_NAME" "$*" >&2; exit 1; }

require() {
  command -v "$1" >/dev/null 2>&1 || fail "Kommando '$1' fehlt auf dem Host."
}
require docker
require jq

# Docker Desktop auf Windows will Windows-Pfade für Bind-Mounts. Unter MinGW/Cygwin
# konvertieren wir daher via `cygpath -w`; auf Linux (CI) bleibt der Pfad wie er ist.
host_path_for_docker() {
  local p="$1"
  if command -v cygpath >/dev/null 2>&1; then
    cygpath -w "$p"
  else
    printf '%s' "$p"
  fi
}

# --- Build ------------------------------------------------------------------
if [ -z "${SKIP_BUILD:-}" ]; then
  log "Baue Verifier-Image: $VERIFIER_IMAGE"
  docker build -t "$VERIFIER_IMAGE" "$SCRIPT_DIR" >/dev/null
fi

# --- Ressourcen zum Aufräumen ----------------------------------------------
declare -a CLEANUP_PROJECTS=()
declare -a CLEANUP_DIRS=()

cleanup() {
  local entry state project dir
  for entry in "${CLEANUP_PROJECTS[@]:-}"; do
    [ -z "$entry" ] && continue
    project="${entry%%:*}"
    state="${entry#*:}"
    fixture_down "$state" "$project"
  done
  for dir in "${CLEANUP_DIRS[@]:-}"; do
    [ -z "$dir" ] && continue
    rm -rf "$dir"
  done
}
trap cleanup EXIT

fixture_up() {
  local state="$1" project="$2"
  local compose_file="$SCRIPT_DIR/fixtures/$state/docker-compose.yml"
  [ -f "$compose_file" ] || fail "Fixture fehlt: $compose_file"
  docker compose -f "$compose_file" -p "$project" up -d --remove-orphans >/dev/null
}

fixture_down() {
  local state="$1" project="$2"
  local compose_file="$SCRIPT_DIR/fixtures/$state/docker-compose.yml"
  docker compose -f "$compose_file" -p "$project" down -v --remove-orphans >/dev/null 2>&1 || true
}

run_verifier() {
  local network="$1" progress_dir="$2" stdout_file="$3" stderr_file="$4"
  local mount_src rc attempt
  mount_src="$(host_path_for_docker "$progress_dir")"
  # Docker Desktop auf Windows liefert gelegentlich EOF auf dem Named-Pipe,
  # wenn `docker run` direkt nach `compose up` erfolgt. Auf Linux (CI) tritt
  # das nicht auf; der Retry kostet dort nichts.
  for attempt in 1 2 3; do
    set +e
    docker run --rm \
      --network "$network" \
      -v "$mount_src:/progress" \
      "$VERIFIER_IMAGE" \
      >"$stdout_file" 2>"$stderr_file"
    rc=$?
    set -e
    if [ "$rc" -ne 125 ] || ! grep -q 'error during connect' "$stderr_file"; then
      break
    fi
    sleep 2
  done
  echo "$rc"
}

# ============================================================================
# Case: solved
# ============================================================================
run_solved_case() {
  local project="verify-${LAB_DIR_NAME}-solved"
  local progress_dir stdout_file stderr_file network exit_code
  progress_dir="$(mktemp -d)"; CLEANUP_DIRS+=("$progress_dir")
  stdout_file="$(mktemp)";     CLEANUP_DIRS+=("$stdout_file")
  stderr_file="$(mktemp)";     CLEANUP_DIRS+=("$stderr_file")

  log "solved: Fixture hoch"
  CLEANUP_PROJECTS+=("$project:solved")
  fixture_up solved "$project"
  network="${project}_default"

  log "solved: erster Verifier-Lauf"
  exit_code="$(run_verifier "$network" "$progress_dir" "$stdout_file" "$stderr_file")"
  local stdout stderr
  stdout="$(cat "$stdout_file")"
  stderr="$(cat "$stderr_file")"

  [ "$exit_code" -eq 0 ] || fail "solved: Exit 0 erwartet, war $exit_code. Stderr: $stderr"
  printf '%s\n' "$stdout" | grep -Eq '^FLAG\{[^}]+\}$' \
    || fail "solved: FLAG{...} fehlt im Stdout. Stdout: $stdout"
  printf '%s\n' "$stdout" | grep -q '✅' \
    || fail "solved: Status-Zeile mit ✅ fehlt im Stdout. Stdout: $stdout"

  local progress_file="$progress_dir/progress.json"
  [ -f "$progress_file" ] || fail "solved: progress.json wurde nicht angelegt"
  jq -e --arg lab "$LAB_NUMBER" '.labs_solved | map(.lab) | index($lab) != null' \
      "$progress_file" >/dev/null \
    || fail "solved: progress.json ohne Eintrag für Lab $LAB_NUMBER"
  jq -e '.version == 1' "$progress_file" >/dev/null \
    || fail "solved: progress.json ohne version=1"
  jq -e --arg lab "$LAB_NUMBER" \
      '.labs_solved | map(select(.lab == $lab)) | .[0].solved_at
       | test("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$")' \
      "$progress_file" >/dev/null \
    || fail "solved: solved_at ist kein ISO-8601-UTC-String"

  # --- Idempotenz --------------------------------------------------------
  log "solved: zweiter Verifier-Lauf (Idempotenz)"
  run_verifier "$network" "$progress_dir" "$stdout_file" "$stderr_file" >/dev/null
  local count
  count="$(jq --arg lab "$LAB_NUMBER" '[.labs_solved[] | select(.lab == $lab)] | length' "$progress_file")"
  [ "$count" = "1" ] || fail "solved: Idempotenz verletzt, Eintrag $count mal vorhanden"

  # --- Kaputte progress.json --------------------------------------------
  log "solved: dritter Verifier-Lauf (kaputte progress.json)"
  printf 'not-json{{' > "$progress_file"
  exit_code="$(run_verifier "$network" "$progress_dir" "$stdout_file" "$stderr_file")"
  stderr="$(cat "$stderr_file")"
  [ "$exit_code" -eq 0 ] \
    || fail "kaputte progress.json: Exit 0 erwartet, war $exit_code"
  jq -e '.' "$progress_file" >/dev/null 2>&1 \
    || fail "kaputte progress.json: Datei wurde nicht durch valides JSON ersetzt"
  printf '%s\n' "$stderr" | grep -qi 'progress' \
    || fail "kaputte progress.json: Hinweis auf Stderr fehlt"

  fixture_down solved "$project"
  ok "solved: alle Assertions grün"
}

# ============================================================================
# Case: unsolved
# ============================================================================
run_unsolved_case() {
  local project="verify-${LAB_DIR_NAME}-unsolved"
  local progress_dir stdout_file stderr_file network exit_code
  progress_dir="$(mktemp -d)"; CLEANUP_DIRS+=("$progress_dir")
  stdout_file="$(mktemp)";     CLEANUP_DIRS+=("$stdout_file")
  stderr_file="$(mktemp)";     CLEANUP_DIRS+=("$stderr_file")

  log "unsolved: Fixture hoch"
  CLEANUP_PROJECTS+=("$project:unsolved")
  fixture_up unsolved "$project"
  network="${project}_default"

  log "unsolved: Verifier-Lauf"
  exit_code="$(run_verifier "$network" "$progress_dir" "$stdout_file" "$stderr_file")"
  local stdout stderr
  stdout="$(cat "$stdout_file")"
  stderr="$(cat "$stderr_file")"

  [ "$exit_code" -eq 1 ] || fail "unsolved: Exit 1 erwartet, war $exit_code. Stdout: $stdout"
  [ -n "$stderr" ] || fail "unsolved: Fehlermeldung auf Stderr fehlt"
  if printf '%s\n' "$stdout" | grep -q 'FLAG{'; then
    fail "unsolved: Stdout darf keine Flag enthalten. Stdout: $stdout"
  fi

  local progress_file="$progress_dir/progress.json"
  if [ -f "$progress_file" ]; then
    jq -e --arg lab "$LAB_NUMBER" '.labs_solved | map(.lab) | index($lab) == null' \
        "$progress_file" >/dev/null \
      || fail "unsolved: progress.json enthält Eintrag für Lab $LAB_NUMBER"
  fi

  fixture_down unsolved "$project"
  ok "unsolved: alle Assertions grün"
}

run_solved_case
run_unsolved_case

ok "Alle Contract-Tests grün für $LAB_DIR_NAME"
