# 03: Modul 0 (Prolog) end-to-end + Frontmatter-Schema

**What to build:** Modul 0 als erstes echtes, komplett konsumierbares Modul. Enthält die Setup-Anleitung (Docker Desktop + Rancher-Desktop-Callout), Kurz-Rekap zu Shell/Ports/HTTP, das Lab (`docker run hello-world` mit Flag im Output) und den echten Verifier `verify-lab-00`. Das Zod-Schema für Modul-Frontmatter ist definiert und ein CI-Job `content-schema` schlägt bei Verstößen an. Ein Teilnehmer kann Modul 0 auf einem frischen Rechner Ende-zu-Ende durcharbeiten.

**Blocked by:** 01, 02

**Status:** ready-for-agent

- [ ] Zod-Schema für Modul-Frontmatter mit `title`, `description`, `type` (`prolog|kern|vertiefung`), `order` (nur bei prolog/kern), `duration_minutes`, `lab_dir`, `verifier_image` — Verstöße brechen den Site-Build
- [ ] CI-Job `content-schema` läuft grün gegen alle vorhandenen Module und schlägt in einem Regressionstest gegen ein bewusst kaputtes Frontmatter fehl
- [ ] Modul-0-Content in `site/src/content/docs/de/prolog/00-setup.md` mit vollständigem Frontmatter und `## Lab`-Abschnitt am Ende
- [ ] `labs/lab-00-hello-world/starter/` und `labs/lab-00-hello-world/solution/` sind angelegt (bei diesem Lab evtl. beide fast leer, weil nur `docker run hello-world` gefragt ist — Autor entscheidet)
- [ ] `verifier/lab-00-hello-world/` mit Verifier-Image, published nach GHCR unter `latest` und `v1`, prüft dass ein `hello-world`-Container mit erwartetem Output gelaufen ist
- [ ] Verifier gibt bei Erfolg `FLAG{...}` plus Zeile `✅ Lab 00 gelöst. Gesamt: 1 / 1` aus, Exit 0, und schreibt `~/.docker-schulung/progress.json`
- [ ] Contract-Test aus Ticket 02 ist für diesen Verifier vollständig implementiert und läuft grün in CI
- [ ] Die Modul-Seite ist über die deployte Site erreichbar und rendert das Lab lesbar
- [ ] Rancher-Desktop-Alternative ist im Setup-Abschnitt als Callout explizit dokumentiert
