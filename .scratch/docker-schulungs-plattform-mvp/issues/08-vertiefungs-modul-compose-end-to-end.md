# 08: Vertiefungs-Modul „Compose" end-to-end

**What to build:** Erstes Vertiefungs-Modul und Referenz-Implementierung des Vertiefungs-Formats. Erklärt Multi-Container-Apps mit `docker compose`, gemeinsame Netze, Service-Abhängigkeiten. Lab: ein Compose-Stack mit App + DB + Reverse-Proxy, den der Teilnehmer korrekt verdrahtet. Dieses Ticket schnitzt die Vertiefungs-Konventionen heraus (kein `order`-Feld im Frontmatter, freie Sortierung in der Navigation) — spätere Vertiefungen sind Copy-Paste-Arbeit nach diesem Muster.

**Blocked by:** 04

**Status:** ready-for-agent

- [ ] Vertiefungs-Frontmatter-Variante im Zod-Schema definiert: `type: vertiefung` ohne `order`, Navigation sortiert alphabetisch oder per optionalem `sort_hint`
- [ ] Modul-Content in `site/src/content/docs/de/vertiefung/compose.md` mit vollständigem Frontmatter
- [ ] `labs/lab-vertiefung-compose/starter/` mit unvollständigem Compose-Stack
- [ ] `labs/lab-vertiefung-compose/solution/` mit funktionierendem Stack
- [ ] `verifier/lab-vertiefung-compose/` prüft, dass App über den Reverse-Proxy erreichbar ist und die DB als Persistenz-Backend funktioniert
- [ ] Contract-Test (solved + unsolved) läuft grün
- [ ] Verifier-Image published nach GHCR
- [ ] Vertiefungs-Rubrik zeigt das Modul; die Landingpage der Rubrik erklärt kurz, dass Reihenfolge frei wählbar ist
- [ ] Autor-README dokumentiert, dass weitere Vertiefungen dieses Modul als Vorlage nehmen sollen
