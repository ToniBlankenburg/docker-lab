# 04: Modul 1 (Container-Grundlagen) end-to-end

**What to build:** Zweites Kern-Modul als vollständige Lerneinheit — Erklärungstext zu `docker run`, `docker ps`, `docker logs`, `docker exec` sowie ein Nginx-Lab, bei dem der Teilnehmer die servierte Seite ändert und die Flag im HTTP-Response-Header findet. Dieses Ticket dient als Stresstest für alle Konventionen aus Ticket 03 (Frontmatter-Schema, Verifier-Harness, Modul-Layout, Autor-Erlebnis). Notwendige Konventions-Anpassungen wandern zurück in die Grundstruktur und werden nicht als Sonderfall im Modul 1 versteckt.

**Blocked by:** 03

**Status:** ready-for-agent

- [ ] Modul-1-Content in `site/src/content/docs/de/kern/01-container-grundlagen.md` mit vollständigem Frontmatter (`type: kern`, `order: 1`) und `## Lab`-Abschnitt
- [ ] `labs/lab-01-container-grundlagen/starter/` mit Nginx-Compose-Setup, das der Teilnehmer anpassen soll
- [ ] `labs/lab-01-container-grundlagen/solution/` mit der Referenz-Antwort (nicht in die Docs verlinkt)
- [ ] `verifier/lab-01-container-grundlagen/` prüft per HTTP-Probe gegen den laufenden Container, findet den erwarteten Response-Header und gibt die Flag aus
- [ ] Contract-Test (solved + unsolved) läuft grün in CI
- [ ] Verifier-Image published nach GHCR mit `latest` und `v1`
- [ ] Modul-Navigation zeigt Modul 1 nach Modul 0 in der Kern-Sektion
- [ ] Konventions-Änderungen (falls beim Bau nötig) sind zurück in Modul 0 und in den Autor-README propagiert — keine Sonderfälle in Modul 1
- [ ] Verifier meldet aggregierten Fortschritt (`✅ Lab 01 gelöst. Gesamt: 2 / …`) korrekt basierend auf der bestehenden `progress.json`
