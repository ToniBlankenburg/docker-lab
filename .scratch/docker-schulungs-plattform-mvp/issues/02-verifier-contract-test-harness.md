# 02: Verifier-Contract-Test-Harness + Dummy-Verifier

**What to build:** Ein wiederverwendbares Test-Harness pro Verifier, das ein `solved`- und ein `unsolved`-Fixture per Docker Compose hochfährt, den Verifier ausführt und Exit-Code, Stdout-Flag sowie den Diff der Fortschrittsdatei prüft. Als Beweis existiert ein Dummy-Verifier `verifier/lab-00-dummy/` mit trivialem `check.sh` und beiden Fixtures. Ein CI-Matrix-Job `verifier-tests` läuft grün gegen den Dummy; ein `release.yml`-Job published die Verifier-Images bei Push auf `main` in GHCR.

**Blocked by:** 01

**Status:** ready-for-agent

- [x] Konvention `verifier/lab-NN-<slug>/` mit `Dockerfile`, `check.sh` (oder `check.py`), `contract-test.sh`, `fixtures/solved/`, `fixtures/unsolved/` ist etabliert und im Autor-README beschrieben
- [x] Das `contract-test.sh` ist so generisch, dass ein Autor es unverändert auf einen neuen Verifier kopieren kann — Lab-spezifische Abweichungen leben ausschließlich in Fixtures und `check.sh`
- [x] Dummy-Verifier `verify-lab-00-dummy` implementiert den Verifier-Contract aus dem Spec: `solved` → Exit 0 + `FLAG{...}` + Progress-Eintrag; `unsolved` → Exit 1 + spoilerfreie Fehlermeldung + kein Progress-Eintrag
- [x] CI-Job `verifier-tests` fährt das Harness pro Verifier-Ordner (Matrix-Strategie) und ist grün
- [x] `release.yml` published bei Merge auf `main` alle geänderten Verifier-Images nach GHCR mit Tags `latest` und `vN`
- [x] Fortschrittsdatei-Format entspricht dem Spec (`version`, `labs_solved[]` mit `lab` und `solved_at` als ISO-8601)
- [x] Verhalten bei kaputter `progress.json`: Verifier ersetzt die Datei mit leerem Zustand und protokolliert auf Stderr

## Comments

**2026-09-16:** Contract-Test-Harness und Dummy-Verifier vollständig umgesetzt.
Der lokale Lauf ist nach Docker-Desktop-Neustart grün: solved, unsolved,
Idempotenz und kaputte `progress.json` bestehen. Zusätzlich umgehen HTTP-Probes
Container-Proxies, Docker-Desktop-EOFs werden im Harness wiederholt und
Windows-Bind-Mount-Pfade werden für Docker Desktop konvertiert.
