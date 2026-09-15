# Verifier

Container-Images pro Lab, die den Zielzustand des Teilnehmer-Setups prüfen und bei Erfolg die Flag ausgeben. Siehe [Spec](../.scratch/docker-schulungs-plattform-mvp/spec.md#verifier-contract) und [ADR-0003](../docs/adr/0003-pro-lab-verifier-mit-kombi-probing.md).

Struktur pro Verifier:

```
verifier/lab-NN/
  Dockerfile
  verify.sh           # oder verify.py
  contract-test.sh    # Solved/Unsolved-Contract-Tests
```

Noch keine Verifier vorhanden — siehe Ticket 02 (generisches Test-Harness) und Ticket 03 (erster Verifier für Modul 0).
