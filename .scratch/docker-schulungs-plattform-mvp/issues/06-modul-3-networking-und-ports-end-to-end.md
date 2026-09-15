# 06: Modul 3 (Networking & Ports) end-to-end

**What to build:** Viertes Kern-Modul — Erklärung zu Port-Publishing (`-p`), Docker-Netzwerken, Container-DNS. Lab: zwei Container laufen im selben benutzerdefinierten Netz und kommunizieren miteinander per Container-Namen; der Teilnehmer muss die Netzwerk-Konfiguration korrekt setzen. Der Verifier joint das Ziel-Netz und probt HTTP gegen den einen Container, dessen Antwort die Flag enthält.

**Blocked by:** 04

**Status:** ready-for-agent

- [ ] Modul-3-Content in `site/src/content/docs/de/kern/03-networking-und-ports.md` mit vollständigem Frontmatter (`type: kern`, `order: 3`)
- [ ] `labs/lab-03-networking-und-ports/starter/` mit zwei Compose-Services, die noch nicht korrekt vernetzt sind
- [ ] `labs/lab-03-networking-und-ports/solution/` mit der Referenz-Netzwerk-Konfiguration
- [ ] `verifier/lab-03-networking-und-ports/` joint das Ziel-Netz, ruft den vorgesehenen Container per DNS-Name auf HTTP und prüft die Antwort
- [ ] Contract-Test (solved + unsolved) läuft grün
- [ ] Verifier-Image published nach GHCR
- [ ] Modul-Navigation zeigt Modul 3 nach Modul 2
