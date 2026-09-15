Status: ready-for-agent

# Spec: Docker-Schulungsplattform (MVP)

Founding-Spec für die interaktive Cloud-Schulungsplattform. Erster ausgebauter Themenbereich ist Docker. Die Plattform-Architektur ist so gebaut, dass weitere Themenbereiche (Kubernetes, CI/CD, …) später als separate Modul-Bündel danebengelegt werden können.

Vokabular in diesem Spec folgt der Domain-Sprache aus [CONTEXT.md](../../CONTEXT.md). Architektur-Entscheidungen aus [docs/adr/](../../docs/adr/) gelten und werden hier nicht neu begründet.

## Problem Statement

Junior-Entwickler ohne Sysadmin-Vorkenntnisse sollen im Rahmen einer größeren Cloud-Schulung solide Docker-Kompetenz aufbauen. Bestehende Angebote sind entweder rein textlastig (kein praktischer Anteil), rein videolastig (kein prüfbarer Erfolg) oder setzen zu viel Linux/Netzwerk-Basiswissen voraus. Kursanbieter haben keine reproduzierbare Plattform, mit der sie eine Docker-Schulung schnell auf verschiedene Kohorten und Sprachen ausrollen können, ohne jedesmal Content zu kopieren und zu pflegen.

Konkret leidet der **Teilnehmer** an: keinem objektiven Feedback („Habe ich das jetzt richtig gelöst?"), Motivations-Einbrüchen bei rein textueller Doku, „Bei mir läuft's nicht"-Problemen ohne Fallback-Anleitung. Der **Autor** leidet an: nicht wiederverwendbarem Content, fehlender i18n-Struktur, keinem klaren Contract, was ein „Modul" liefern muss.

## Solution

Eine **Docker-Schulungsplattform** als Git-Repo, das drei Artefakte zusammen ausliefert:

1. Eine **statische Docs-Site** (Astro Starlight, [ADR-0001](../../docs/adr/0001-astro-starlight-als-docs-fundament.md)) mit den Modul-Erklärungen, gedeployed auf GitHub Pages. Deutsch primär, Englisch als spätere Übersetzung ([ADR-0002](../../docs/adr/0002-deutsch-primary-englisch-uebersetzung.md)).
2. Ein **Lab pro Modul** mit Boilerplate-Sourcen (Starter) und Musterlösung, ausgeführt lokal via Docker Desktop oder Rancher Desktop auf dem Teilnehmer-Rechner.
3. Ein **Verifier-Container pro Lab** (`docker-schulung/verify-lab-NN`), der den Zielzustand prüft, eine Flag im Format `FLAG{<slug>}` ausgibt und den Fortschritt in `~/.docker-schulung/progress.json` schreibt ([ADR-0003](../../docs/adr/0003-pro-lab-verifier-mit-kombi-probing.md)).

Der Teilnehmer arbeitet den linearen **Kern-Track** (5 Module) durch, wählt danach frei aus **Vertiefungs-Modulen** und sieht seinen Fortschritt am Ende jedes Verifier-Laufs. Der Autor bekommt eine klare Content-Contract-Struktur, in der ein neues Modul aus einer Markdown-Datei + Lab-Ordner + Verifier-Ordner besteht — alles im selben Repo, atomar in einem PR änderbar.

## User Stories

### Teilnehmer

1. Als Teilnehmer möchte ich vor Kursbeginn eine Liste unterstützter Betriebssysteme und Docker-Runtimes (Docker Desktop, Rancher Desktop) sehen, damit ich sicher bin, dass der Kurs auf meinem Rechner läuft.
2. Als Teilnehmer möchte ich im Prolog-Modul (Modul 0) grundlegende Shell-, Port- und HTTP-Konzepte kurz erklärt bekommen, damit ich in Modul 1 nicht wegen fehlender Basics stolpere.
3. Als Teilnehmer möchte ich im Prolog-Modul mit einem sehr einfachen Lab (z. B. `docker run hello-world` und Flag im Output finden) sofort einen ersten Erfolg erleben, damit ich Vertrauen ins Format aufbaue.
4. Als Teilnehmer möchte ich pro Modul eine geschätzte Bearbeitungszeit sehen, damit ich meine Lernzeit planen kann.
5. Als Teilnehmer möchte ich jedes Kern-Modul in fester Reihenfolge durcharbeiten, damit spätere Konzepte auf vorherigen aufbauen.
6. Als Teilnehmer möchte ich nach Abschluss aller Kern-Module frei aus Vertiefungs-Modulen wählen, damit ich in mich interessierende Themen tiefer eintauchen kann.
7. Als Teilnehmer möchte ich am Ende jedes Labs den Verifier-Container per einheitlichem Kommando starten (`docker run --rm docker-schulung/verify-lab-NN`), damit ich meinen Erfolg objektiv nachweise.
8. Als Teilnehmer möchte ich bei erfolgreichem Lab eine sichtbare Flag im Format `FLAG{...}` sehen, damit ich einen greifbaren Erfolgsmoment habe.
9. Als Teilnehmer möchte ich bei fehlgeschlagenem Lab eine hilfreiche Fehlermeldung vom Verifier sehen (z. B. „Ziel-Container nicht auf Port 8080 erreichbar"), damit ich weiß, wo ich weiterschauen muss — ohne Spoiler zur Musterlösung.
10. Als Teilnehmer möchte ich am Ende jedes Verifier-Laufs meinen Gesamt-Fortschritt sehen (z. B. „Lab 3 von 8 gelöst"), damit ich sehe, wo ich im Kurs stehe.
11. Als Teilnehmer möchte ich, dass mein Fortschritt lokal auf meiner Maschine bleibt (`~/.docker-schulung/progress.json`), damit ich keine Registrierung, Login oder Server-Konto brauche.
12. Als Teilnehmer möchte ich zwischen Deutsch und Englisch als Anzeigesprache umschalten können, damit ich in meiner bevorzugten Sprache lerne (Englisch mit Feature-Lag akzeptiert).
13. Als Teilnehmer möchte ich die Docs-Site auch offline lesen können, indem das Repo geklont wird, damit ich im Zug oder ohne stabile Verbindung weiterarbeite.
14. Als Teilnehmer möchte ich in Labs, die Docker-Socket-Mount nutzen, einen klaren Hinweis sehen, dass dies ein Anti-Pattern für Produktion ist, damit ich diese Praxis nicht ungewollt in echte Projekte übernehme.

### Autor

15. Als Autor möchte ich ein neues Modul durch Anlegen einer Markdown-Datei (mit definiertem Frontmatter-Schema) und optional eines `labs/lab-NN/`-Ordners plus `verifier/lab-NN/`-Ordners hinzufügen, damit die Struktur mir keine Freiheitsgrade beim Layout gibt.
16. Als Autor möchte ich, dass ein CI-Check das Frontmatter jedes Moduls gegen ein Schema validiert, damit ich strukturelle Fehler nicht erst beim Site-Build entdecke.
17. Als Autor möchte ich Content-Änderung und passende Verifier-Anpassung im selben PR machen können, damit Modul und Prüf-Logik nicht auseinanderdriften.
18. Als Autor möchte ich pro Lab eine Musterlösung im Repo halten (unter `labs/lab-NN/solution/`), damit ich beim Editieren des Moduls schnell nachvollziehe, worauf der Verifier prüft.
19. Als Autor möchte ich, dass Verifier-Images bei Merge auf `main` automatisch gebuildet und in GHCR gepublished werden, damit ich keine manuelle Release-Ceremony pflegen muss.
20. Als Autor möchte ich Verifier-Images mit einer stabilen Tag-Konvention (`vN` + `latest`) publishen, damit Teilnehmer nicht mit inkompatiblen Verifiern arbeiten.
21. Als Autor möchte ich, dass die Docs-Site bei Merge auf `main` automatisch neu gebaut und auf GitHub Pages deployed wird, damit Teilnehmer stets die aktuelle Version sehen.
22. Als Autor möchte ich pro Verifier einen Contract-Test ausführen, der prüft, dass der Verifier gegen ein „solved"-Setup Exit 0 + Flag ausgibt und gegen ein „unsolved"-Setup Exit 1 + Fehlermeldung, damit ich Regressionen früh erkenne.
23. Als Autor möchte ich das Plattform-Vokabular aus `CONTEXT.md` konsistent verwenden, damit die Sprache im Content stabil bleibt (siehe [docs/agents/domain.md](../../docs/agents/domain.md)).

### Kunde / Auftraggeber (Firma, die die Schulung ihren Devs anbietet)

24. Als Kunde möchte ich die Plattform mit einem Fork oder Deploy auf eigener Infrastruktur betreiben können, damit interne Datenschutz-Vorgaben eingehalten werden.
25. Als Kunde möchte ich, dass die Plattform auch mit Rancher Desktop statt Docker Desktop funktioniert, damit ich nicht in Docker Desktop Lizenzkosten stolpere (> 250 MA / > $10 M Umsatz).
26. Als Kunde möchte ich den Fortschrittsstand meines Teilnehmers optional durch dessen `progress.json`-Datei nachweisen können, damit ich einfache Assessments ohne zentrales System handhaben kann.

## Implementation Decisions

Feste Entscheidungen aus den Grill-Runden und den ADRs. Wo hier etwas explizit als „Empfehlung" markiert ist, ist es weniger fest und darf beim ersten Ticket noch geändert werden.

### Modul-Bogen

**Kern-Track (5 Module, in fester Reihenfolge):**

- **Modul 0 – Prolog / Setup**: Shell-Basics, Ports, HTTP-Rekap, Docker Desktop / Rancher installieren. Lab: `docker run hello-world`, Flag im Output finden.
- **Modul 1 – Container-Grundlagen**: `docker run`, `docker ps`, `docker logs`, `docker exec`. Lab: Nginx-Container starten, Seite ändern, Flag im Response-Header.
- **Modul 2 – Images & Dockerfiles**: Layer, `docker build`, Cache. Lab: Python-App containerisieren, Flag = Build-Zeit unter Schwelle X dank korrektem Layer-Cache.
- **Modul 3 – Networking & Ports**: `-p`, `--network`, Container-DNS. Lab: Zwei Container reden miteinander, Flag im Response.
- **Modul 4 – Volumes & Persistenz**: Named Volumes, Bind Mounts. Lab: DB-Container überlebt Neustart, Flag = Daten intakt.

**Vertiefungs-Kandidaten (Autor wählt Umfang, mind. 2 im MVP):**

- Compose (Multi-Container-Apps)
- Multi-Stage-Builds & Image-Size-Optimierung
- Registries & Image-Distribution
- Health, Logging, Debugging in der Praxis
- Docker in CI (Vorbereitung auf CI/CD-Modul)

Security wird bewusst nicht als eigenes Modul gebaut. Einzelne Aspekte (Non-Root-User im Dockerfile, Socket-Mount-Warnungen) werden in Kern-Module verstreut.

### Repo-Layout

Monorepo mit klaren Top-Level-Bereichen:

- `site/` – Astro Starlight Content und Konfiguration. Content unter `site/src/content/docs/de/...` und `site/src/content/docs/en/...` mit den Unterordnern `prolog/`, `kern/`, `vertiefung/`.
- `labs/lab-NN-<slug>/` – Ziel-Container-Sourcen pro Lab. Enthält `starter/` (Boilerplate für Teilnehmer) und `solution/` (Musterlösung, sichtbar im Repo, nicht in die Docs-Site verlinkt).
- `verifier/lab-NN/` – Verifier-Sourcen pro Lab. Enthält `Dockerfile` und Prüf-Skript.
- `docs/adr/` – Architektur-Entscheidungen (bereits vorhanden).
- `docs/agents/` – Agenten-Setup (bereits vorhanden).
- `.scratch/` – lokaler Issue-Tracker (bereits vorhanden).
- `.github/workflows/` – CI-Jobs.
- `CONTEXT.md`, `AGENTS.md` an Root (bereits vorhanden).

Ein **Modul** ist eine einzelne Markdown-Datei in `site/src/content/docs/de/kern/` bzw. `.../vertiefung/`. Die Datei enthält den Erklärungstext und am Ende einen `## Lab`-Abschnitt mit der Aufgabenstellung. Die Modul-Datei verlinkt auf den zugehörigen `labs/lab-NN-.../starter/`-Ordner. Ein Ordner-pro-Modul-Ansatz wird bewusst _nicht_ genommen — flache Dateien passen zu Starlights Default-Konventionen und halten die Navigation einfach.

### Content-Frontmatter-Contract

Jede Modul-Datei hat Frontmatter mit mindestens:

- `title` (String) — Anzeigetitel
- `description` (String) — Kurzbeschreibung für Suche und Übersicht
- `type` (Enum: `prolog` | `kern` | `vertiefung`) — Modul-Typ
- `order` (Integer, nur bei `kern` und `prolog`) — Reihenfolge im linearen Track
- `duration_minutes` (Integer) — geschätzte Bearbeitungszeit
- `lab_dir` (Pfad, relativ zu Repo-Root) — Ordner mit Starter-Code
- `verifier_image` (String) — Verifier-Image-Referenz (z. B. `ghcr.io/<org>/docker-schulung/verify-lab-01:latest`)

Ein Zod-Schema (Typ-Definition im `site/`-Package) validiert das Frontmatter beim Site-Build und in einem separaten CI-Check. Verstoß = harter Fehler.

### Verifier-Contract

Jeder Verifier ist ein eigenständiges Container-Image `ghcr.io/<org>/docker-schulung/verify-lab-NN`. Standardaufruf:

```
docker run --rm \
  --network docker-schulung-lab-NN \
  -v $HOME/.docker-schulung:/progress \
  ghcr.io/<org>/docker-schulung/verify-lab-NN:latest
```

Für Labs mit Introspektions-Bedarf zusätzlich `-v /var/run/docker.sock:/var/run/docker.sock:ro` — im Modul-Text explizit als Anti-Pattern gekennzeichnet.

Verifier-Verhalten:

- **Erfolg**: Stdout enthält `FLAG{<slug>}`, sowie `✅ Lab N gelöst. Gesamt: X / Y`. Exit-Code 0. `progress.json` wird um Eintrag `{ "lab": "NN", "solved_at": "<ISO-8601>" }` ergänzt (idempotent — mehrfaches Lösen ändert `solved_at` nicht).
- **Misserfolg**: Stderr enthält kurze, spoilerfreie Fehlermeldung („Ziel-Container nicht auf Port 8080 erreichbar", nicht: „In deinem Dockerfile fehlt `EXPOSE 8080`"). Exit-Code 1. `progress.json` bleibt unverändert.

Prüf-Skript ist ein Shell-Script oder Python-Script (Autor entscheidet pro Lab). Empfehlung: Shell für simple Netzwerk-Probes, Python für komplexere Introspektion.

### Fortschrittsdatei

Format:

```json
{
  "version": 1,
  "labs_solved": [
    { "lab": "01", "solved_at": "2026-09-15T10:23:00Z" }
  ]
}
```

Der Verifier ist die einzige Instanz, die schreibt. Bei fehlender Datei legt der Verifier sie an. Bei kaputter Datei (Parse-Fehler): Verifier startet neu mit leerem Array und protokolliert die Ersetzung auf Stderr. Kein zentrales Sync, kein Cloud-Export im MVP.

### Deploy und CI

- **Site-Deploy**: GitHub Pages, gebaut aus `site/` per GitHub Actions Workflow, ausgelöst bei Push auf `main`.
- **Verifier-Images**: GHCR (nicht Docker Hub), publiziert per GitHub Actions bei Push auf `main`. Tags: `latest` und `vN` (händisches Bump im PR).
- **CI-Jobs** in einem `ci.yml`:
  - `content-schema` — Zod-Validation aller Modul-Frontmatter
  - `site-build` — `astro build` läuft grün, keine kaputten internen Links
  - `verifier-tests` — Contract-Tests pro Lab (siehe Testing Decisions)
- **Release-Workflow** in `release.yml`:
  - `site-deploy` — nach `ci.yml` grün, Push auf `main`: Site auf GitHub Pages
  - `verifier-publish` — nach `ci.yml` grün, Push auf `main`: geänderte Verifier-Images nach GHCR

### Docker-Runtime-Support

Docker Desktop primär, Rancher Desktop als lizenzfreie Alternative im Prolog-Modul dokumentiert. Podman wird im MVP nicht explizit unterstützt (Compose-Verhalten weicht ab).

### Sprache

Alle Content-Dateien zuerst auf Deutsch. Englische Übersetzung erlaubt Feature-Lag. Fach-Vokabular (Image, Container, Volume, Registry) bleibt in beiden Sprachen englisch. Plattform-Vokabular (Modul, Lab, Flag, Verifier) siehe CONTEXT.md.

## Testing Decisions

### Was macht einen guten Test hier aus

Nur externes Verhalten testen: den Verifier-Contract (Eingabe: Docker-Setup-Zustand; Ausgabe: Stdout, Stderr, Exit-Code, `progress.json`-Diff). Nicht getestet werden interne Implementations-Details des Prüf-Skripts (welche `docker inspect`-Aufrufe es macht, welche Bash-Funktionen intern existieren). Ein Test soll robust bleiben, wenn ein Autor das Prüf-Skript umbaut, solange der Verifier-Contract gleich bleibt.

### Haupt-Seam: Verifier-Contract pro Lab

Ein Testfall pro Lab, jeweils in zwei Varianten:

- **Solved**: Docker-Compose-Fixture startet den Ziel-Container im gelösten Zustand (Musterlösung aus `labs/lab-NN/solution/`). Der Verifier wird gerufen; erwartet: Exit 0, Flag in Stdout, `progress.json` inkrementiert.
- **Unsolved**: Fixture startet den Ziel-Container mit dem Starter-Code (bewusst noch nicht gelöst). Verifier wird gerufen; erwartet: Exit 1, spoilerfreie Fehlermeldung auf Stderr, `progress.json` unverändert.

Tests laufen in GitHub Actions in einem Job pro Lab (Matrix-Strategie). Prior Art: gibt es im Repo noch nicht (greenfield). Empfehlung: das Test-Harness selbst ist ein einfaches Shell-Skript im Root des jeweiligen Verifier-Ordners (`verifier/lab-NN/contract-test.sh`), das Docker-Compose hochfährt, den Verifier ruft, die Assertions macht und aufräumt.

### Smoke-Tests

- **Content-Schema-Check**: Zod-Schema wird über alle `.md`-Dateien in `site/src/content/docs/` gezogen. Schnell (Sekunden). Prior Art: keine im Repo, aber Starlight nutzt intern bereits Zod für Frontmatter — dieselbe Bibliothek wiederverwenden.
- **Site-Build**: `astro build` in `site/`. Kaputte interne Links, fehlende Bilder oder Schema-Verstöße brechen den Build. Prior Art: Starlight-Standard.

### Bewusst nicht getestet in CI

- End-to-End-Teilnehmerpfad („Person folgt Modul-Text Schritt für Schritt"). Wird im Modul-Review manuell einmal pro Release durchgespielt und in einem Checklisten-Dokument abgehakt (nicht Teil dieses MVP-Spec, kann später als eigenes Ticket kommen).
- Cross-Browser-Rendering der Site (Starlight ist ein etabliertes Framework, Rendering-Regressionen sind unwahrscheinlich).
- Performance der Verifier-Prüfungen (kein SLA-Kandidat im MVP).

## Out of Scope

- Zentrales Progress-Tracking, Server-Backend, Login, Leaderboard, Zertifikatsgenerierung. Wird kein Bestandteil des MVP; Fortschritt bleibt lokal ([ADR-0003](../../docs/adr/0003-pro-lab-verifier-mit-kombi-probing.md)).
- Ein natives Progress-CLI (`docker-schulung status`). Ausgabe kommt ausschließlich vom Verifier.
- Interaktive Playgrounds im Browser (In-Page-Terminal, WebContainer o. ä.). Alle Labs laufen lokal auf dem Teilnehmer-Rechner.
- Video-Content, Audio-Erklärungen. Reines Markdown ist der Content-Modus. Video kann später selektiv nachgerüstet werden.
- Anti-Cheat / Anti-Copy-Paste-Mechanik. Flags sind auf allen Rechnern gleich; Copy-Paste zwischen Teilnehmern bleibt möglich und bewusst ignoriert.
- Podman-Support als First-Class-Runtime.
- Kubernetes-, CI/CD-, Serverless-Module. Kommen später als eigene Modul-Bündel im selben Repo daneben, jeder mit eigener Spec.
- Trainer-geführte Live-Formate (Slides, Trainer-Notes). Der Kurs ist selbstgeführt-first; Live-Q&A ist möglich, aber nicht im MVP-Content.
- Trockene Übersetzung nach Englisch vor dem ersten Kunden. EN läuft als Übersetzung hinterher.
- Zertifiziertes, proctored Assessment. Kann später als separater Modus danebengelegt werden, ohne den Lern-Track anzufassen.

## Further Notes

- Dieser Spec ist der Founding-Spec des Repos. Er zieht mehr Fäden als ein normaler Feature-Spec, weil er die Grundstruktur festlegt. Nachfolgende Specs (z. B. „Modul 5 hinzufügen") werden deutlich schmaler.
- Die im Grilling nicht komplett ausgetragene Runde 4 (Repo-Layout, Verifier-Ort, Deploy-Ziel) ist hier mit begründeten Default-Entscheidungen niedergelegt. Falls beim ersten Ticket eine der Default-Entscheidungen aus praktischen Gründen umgebaut werden muss, ist das keine Katastrophe — vor dem ersten Merge auf `main` sind alle Layout-Entscheidungen billig umkehrbar.
- Ticket-Aufteilung folgt in einem separaten `/to-tickets`-Lauf. Vorschau der wahrscheinlichen Tracer-Bullet-Reihenfolge: (1) Repo-Skeleton + Starlight-Setup + CI-Grundgerüst, (2) Verifier-Contract-Test-Harness generisch, (3) Modul 0 (Prolog) end-to-end als Referenz-Implementierung, (4) Modul 1 als zweites Beispiel um Layout zu validieren, (5) restliche Kern-Module, (6) erste Vertiefungs-Module, (7) EN-Übersetzung des Prologs als Proof für die i18n-Pipeline.
- Die Namensräume `docker-schulung/*` und `ghcr.io/<org>/docker-schulung/*` müssen früh beim GitHub-Org festgelegt werden. Ein `/wizard`-Lauf könnte das Registry- und Pages-Setup interaktiv leisten, sobald ein GitHub-Org steht.
