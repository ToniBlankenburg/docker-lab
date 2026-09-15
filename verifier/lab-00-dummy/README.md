# Lab 00 — Dummy-Verifier

Referenz-Implementierung des Verifier-Contracts aus dem [MVP-Spec](../../.scratch/docker-schulungs-plattform-mvp/spec.md#verifier-contract) und [ADR-0003](../../docs/adr/0003-pro-lab-verifier-mit-kombi-probing.md). Existiert ausschließlich, um das generische `contract-test.sh`-Harness zu belegen. Wird **nicht** einem Teilnehmer ausgeliefert und bekommt kein Modul in der Docs-Site.

## Zielzustand

Ein Ziel-Container ist unter dem DNS-Namen `target` auf Port `80` erreichbar und antwortet mit HTTP 200 und einem Body, der die Zeichenkette `SOLVED` enthält.

## Ausgabe

- **Erfolg** — Stdout enthält `FLAG{dummy-solved}` und `✅ Lab 00 gelöst. Gesamt: X / 1`. Exit 0. `progress.json` bekommt idempotent einen Eintrag für Lab `00`.
- **Misserfolg** — Stderr enthält eine spoilerfreie Meldung, Exit 1, `progress.json` unverändert.
- **Kaputte `progress.json`** — Datei wird durch leeren Zustand ersetzt; Hinweis auf Stderr.

## Contract-Tests lokal

```bash
bash verifier/lab-00-dummy/contract-test.sh
```

Voraussetzungen: Docker-Daemon läuft, `docker compose` und `jq` sind installiert.
