# 05: Modul 2 (Images & Dockerfiles) end-to-end

**What to build:** Drittes Kern-Modul — Erklärung zu Image-Layern, `docker build`, Layer-Caching. Lab: der Teilnehmer containerisiert eine kleine Python-App und optimiert das Dockerfile so, dass Rebuild-Zeit unter einer definierten Schwelle bleibt. Der Verifier prüft per Docker-Socket-Introspektion, weshalb dieses Modul den didaktischen Anker für die **Socket-Mount-Anti-Pattern-Warnung** setzt: im Modul-Text wird explizit erklärt, dass Socket-Zugriff in Produktion tabu ist und nur hier zu Lernzwecken vorgeführt wird.

**Blocked by:** 04

**Status:** ready-for-agent

- [ ] Modul-2-Content in `site/src/content/docs/de/kern/02-images-und-dockerfiles.md` mit vollständigem Frontmatter (`type: kern`, `order: 2`)
- [ ] `## Lab`-Abschnitt inklusive explizitem Callout: „Der Verifier braucht Zugriff auf den Docker-Socket. In Produktions-Setups ist das ein bekanntes Anti-Pattern — hier lernst du früh, es zu erkennen"
- [ ] `labs/lab-02-images-und-dockerfiles/starter/` mit unoptimiertem Dockerfile für eine Python-App
- [ ] `labs/lab-02-images-und-dockerfiles/solution/` mit optimiertem Dockerfile (Layer-Reihenfolge, Cache-Nutzung)
- [ ] `verifier/lab-02-images-und-dockerfiles/` bindet den Docker-Socket read-only ein, misst Rebuild-Zeit nach einer Content-Änderung und prüft die Schwelle
- [ ] Contract-Test (solved + unsolved) läuft grün, inklusive Socket-Mount in der Test-Harness-Aufrufkonvention
- [ ] Verifier-Image published nach GHCR
- [ ] Modul-Navigation zeigt Modul 2 nach Modul 1
