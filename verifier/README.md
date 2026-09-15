# Verifier

Container-Images pro Lab, die den Zielzustand des Teilnehmer-Setups prüfen und bei Erfolg die Flag ausgeben. Siehe [Spec](../.scratch/docker-schulungs-plattform-mvp/spec.md#verifier-contract) und [ADR-0003](../docs/adr/0003-pro-lab-verifier-mit-kombi-probing.md).

## Autor-Konvention

Ein neuer Verifier ist ein Ordner `verifier/lab-NN-<slug>/` mit dieser Struktur:

```
verifier/lab-NN-<slug>/
  Dockerfile              # baut das Verifier-Image
  check.sh                # (oder check.py) — Prüf-Logik, ENTRYPOINT
  contract-test.sh        # kopiere unverändert aus lab-00-dummy/
  VERSION                 # einzelne Zeile "N" für den vN-Tag beim Publish
  README.md               # Zielzustand + Ausgabe-Contract
  fixtures/
    solved/
      docker-compose.yml  # startet den Ziel-Container im gelösten Zustand
      ...                 # zusätzliche Assets (html, Konfigs, Seed-Daten)
    unsolved/
      docker-compose.yml  # startet den Ziel-Container im ungelösten Zustand
      ...
```

Der Ziel-Container heißt im Compose-File **immer `target`** — das ist der DNS-Name, gegen den `check.sh` probt. Das `contract-test.sh` ist bewusst so generisch, dass Autoren es unverändert kopieren; Lab-spezifische Abweichungen leben ausschließlich in `fixtures/` und `check.sh`.

Der `LAB_NUMBER` wird aus dem Ordnernamen abgeleitet (`lab-00-dummy` → `00`). `check.sh` setzt die übrigen Contract-Parameter (`LAB_SLUG`, `LAB_TOTAL`, `TARGET_PORT` …) als Defaults im Dockerfile per `ENV`.

## Contract (verkürzt)

- **Solved** — Stdout `FLAG{<slug>}` + `✅ Lab NN gelöst. Gesamt: X / Y`, Exit 0, idempotenter Eintrag in `progress.json`.
- **Unsolved** — spoilerfreie Meldung auf Stderr, Exit 1, `progress.json` unverändert.
- **Kaputte `progress.json`** — Datei wird durch leeren Zustand ersetzt; Hinweis auf Stderr.

Details im [MVP-Spec](../.scratch/docker-schulungs-plattform-mvp/spec.md#verifier-contract).

## Tests

Lokal pro Verifier:

```bash
bash verifier/lab-NN-<slug>/contract-test.sh
```

In CI läuft `contract-test.sh` als Matrix-Job (`verifier-tests`) automatisch pro Verifier-Ordner. Referenz-Implementierung liegt in [`lab-00-dummy/`](lab-00-dummy/).

## Publish

Der Release-Workflow (`.github/workflows/release.yml`) baut bei Push auf `main` jedes Verifier-Image und published es nach GHCR mit den Tags `latest` und `vN`, wobei `N` aus der `VERSION`-Datei des Verifiers stammt. Bump beim Merge-PR, wenn sich der Contract ändert.
