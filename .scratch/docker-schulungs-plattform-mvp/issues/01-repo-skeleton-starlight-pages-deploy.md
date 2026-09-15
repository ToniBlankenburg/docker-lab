# 01: Repo-Skeleton + leere Starlight-Site + Pages-Deploy

**What to build:** Das Grundgerüst des Monorepos steht: `site/` hostet eine leere, aber lauffähige Astro-Starlight-Site mit DE- und EN-Sprachumschalter und den drei Rubriken Prolog / Kern / Vertiefung als leere Platzhalter. Ein GitHub-Actions-Workflow published die Site bei Push auf `main` auf GitHub Pages. Ein Reviewer öffnet die deployte URL und sieht die leere Site samt Sprachumschalter.

**Blocked by:** None (kann sofort starten)

**Status:** ready-for-agent

- [ ] `site/` enthält ein funktionierendes Astro-Starlight-Setup mit Zod-Content-Collections-Konfiguration (auch wenn noch kein Modul liegt)
- [ ] Starlights i18n-Konfig kennt `de` (Default) und `en`, mit Sprachumschalter in der Seitennavigation
- [ ] Sidebar-Struktur zeigt die drei leeren Rubriken „Prolog", „Kern", „Vertiefung"
- [ ] `verifier/`, `labs/`, `.github/workflows/` sind angelegt (mit Platzhaltern oder README-Stubs, wenn leer)
- [ ] GitHub-Actions-Workflow `ci.yml` mit Job `site-build` läuft grün gegen die leere Site
- [ ] GitHub-Actions-Workflow `release.yml` deployed nach `main`-Push die Site auf GitHub Pages
- [ ] Deploy-URL öffnet sich, zeigt Startseite, Sprachumschalter funktioniert (auch wenn EN nur eine leere Landingpage zeigt)
- [ ] `README.md` im Repo-Root erklärt in wenigen Zeilen die Top-Level-Struktur
