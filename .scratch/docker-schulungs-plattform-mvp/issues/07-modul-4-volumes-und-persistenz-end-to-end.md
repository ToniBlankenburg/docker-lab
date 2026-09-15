# 07: Modul 4 (Volumes & Persistenz) end-to-end

**What to build:** Letztes Kern-Modul — Erklärung zu Named Volumes, Bind Mounts, Persistenz-Semantik. Lab: eine DB (z. B. Postgres oder SQLite in einem Container) überlebt einen `docker restart`, weil die Daten auf einem Volume liegen; der Teilnehmer setzt Mount-Konfiguration korrekt. Nach diesem Ticket ist der **Kern-Track vollständig** und der lineare Pflicht-Teil des Kurses konsumierbar von Prolog bis Modul 4.

**Blocked by:** 04

**Status:** ready-for-agent

- [ ] Modul-4-Content in `site/src/content/docs/de/kern/04-volumes-und-persistenz.md` mit vollständigem Frontmatter (`type: kern`, `order: 4`)
- [ ] `labs/lab-04-volumes-und-persistenz/starter/` mit DB-Container ohne persistente Konfiguration
- [ ] `labs/lab-04-volumes-und-persistenz/solution/` mit korrekter Volume-Konfiguration
- [ ] `verifier/lab-04-volumes-und-persistenz/` startet den Ziel-Container, schreibt Testdaten, restartet den Container, prüft ob die Daten noch da sind, gibt die Flag aus
- [ ] Contract-Test (solved + unsolved) läuft grün
- [ ] Verifier-Image published nach GHCR
- [ ] Modul-Navigation zeigt Modul 4 nach Modul 3, Kern-Rubrik ist damit vollständig
- [ ] Site-Landingpage / Prolog-Text weist darauf hin, dass nach Modul 4 die Vertiefungs-Module in beliebiger Reihenfolge offen stehen
