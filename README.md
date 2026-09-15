# Cloud-Schulung

Repo für die interaktive Cloud-Schulungsplattform. Erster ausgebauter Themenbereich: **Docker**. Siehe [CONTEXT.md](CONTEXT.md) für das Domain-Vokabular und [docs/adr/](docs/adr/) für die Architektur-Entscheidungen.

## Top-Level-Struktur

| Ordner                 | Zweck                                                                                                     |
| ---------------------- | --------------------------------------------------------------------------------------------------------- |
| `site/`                | Astro-Starlight-Docs-Site (DE primär, EN Übersetzung). Deployed nach GitHub Pages via `release.yml`.      |
| `labs/`                | Ziel-Container-Sourcen pro Lab (`starter/` + `solution/`). Noch leer, siehe Ticket 03 aufwärts.           |
| `verifier/`            | Verifier-Container-Images pro Lab (prüft Zielzustand, gibt Flag aus). Noch leer, siehe Ticket 02 / 03.    |
| `docs/adr/`            | Architektur-Entscheidungen (MADR-light).                                                                  |
| `docs/agents/`         | Konventionen für Agenten-Workflows (Issue-Tracker, Triage-Labels, Domain-Docs).                           |
| `.scratch/`            | Lokaler Issue-Tracker (Specs + Tickets pro Feature).                                                      |
| `.github/workflows/`   | CI (`ci.yml` — Site-Build) und Release (`release.yml` — Pages-Deploy).                                    |
| `CONTEXT.md`           | Domain-Vokabular der Plattform. Vor Content-Änderungen konsultieren.                                      |
| `AGENTS.md`            | Einstiegspunkt für Agenten-Skills in diesem Repo.                                                         |

## Site lokal entwickeln

```bash
cd site
npm install
npm run dev      # http://localhost:4321
npm run build    # statischer Build nach site/dist/
```

## Deploy

Der Release-Workflow (`.github/workflows/release.yml`) baut die Site bei jedem Push auf `main` und published sie auf GitHub Pages.

Für **project-Pages** (Standard, URL `https://<owner>.github.io/<repo>/`) reichen die Defaults — `SITE_URL` und `SITE_BASE` werden aus dem Repo-Kontext abgeleitet. Für **user/org-Pages** (URL `https://<owner>.github.io/`) im Repo unter Settings → Secrets and variables → Actions → Variables setzen:

- `SITE_URL` = `https://<owner>.github.io`
- `SITE_BASE` = `/`

Aktivieren: Repo-Settings → Pages → Source = "GitHub Actions".

## Ticket-Workflow

Specs und Tickets liegen unter `.scratch/<feature>/` (siehe [docs/agents/issue-tracker.md](docs/agents/issue-tracker.md)). Aktueller Feature-Spec: [.scratch/docker-schulungs-plattform-mvp/spec.md](.scratch/docker-schulungs-plattform-mvp/spec.md).
