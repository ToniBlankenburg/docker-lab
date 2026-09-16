# 01: Repo-Skeleton + leere Starlight-Site + Pages-Deploy

**What to build:** Das Grundgerüst des Monorepos steht: `site/` hostet eine leere, aber lauffähige Astro-Starlight-Site mit DE- und EN-Sprachumschalter und den drei Rubriken Prolog / Kern / Vertiefung als leere Platzhalter. Ein GitHub-Actions-Workflow published die Site bei Push auf `main` auf GitHub Pages. Ein Reviewer öffnet die deployte URL und sieht die leere Site samt Sprachumschalter.

**Blocked by:** None (kann sofort starten)

**Status:** ready-for-agent

- [x] `site/` enthält ein funktionierendes Astro-Starlight-Setup mit Zod-Content-Collections-Konfiguration (auch wenn noch kein Modul liegt)
- [x] Starlights i18n-Konfig kennt `de` (Default) und `en`, mit Sprachumschalter in der Seitennavigation
- [x] Sidebar-Struktur zeigt die drei leeren Rubriken „Prolog", „Kern", „Vertiefung"
- [x] `verifier/`, `labs/`, `.github/workflows/` sind angelegt (mit Platzhaltern oder README-Stubs, wenn leer)
- [x] GitHub-Actions-Workflow `ci.yml` mit Job `site-build` läuft grün gegen die leere Site
- [x] GitHub-Actions-Workflow `release.yml` deployed nach `main`-Push die Site auf GitHub Pages
- [ ] Deploy-URL öffnet sich, zeigt Startseite, Sprachumschalter funktioniert (auch wenn EN nur eine leere Landingpage zeigt)
- [x] `README.md` im Repo-Root erklärt in wenigen Zeilen die Top-Level-Struktur

## Comments

**2026-09-16:** Skeleton komplett vorhanden (in `init`-Commit und HEAD zusammen).
`npm run check` und `npm run build` in `site/` laufen grün (9 Pages).
`ci.yml` hat `site-build`-Job gegen `site/package-lock.json`. `release.yml` hat
`site-deploy` mit `actions/deploy-pages@v4`, `SITE_URL`/`SITE_BASE` aus Repo-Variables
mit sinnvollen project-Pages-Defaults. Starlight-i18n konfiguriert `de` (default) + `en`
mit Sprachumschalter; DE- und EN-Index-, Prolog-, Kern-, Vertiefung-Stubs vorhanden.
Root-`README.md` erklärt Top-Level-Struktur und Deploy-Anleitung.

Offen: Deploy-URL kann erst nach dem ersten Merge auf `main` mit aktivierten
GitHub-Pages-Settings verifiziert werden — nicht Agent-lokal prüfbar. Checkbox
bleibt bewusst offen; Reviewer setzt sie nach erstem grünen Pages-Deploy.
