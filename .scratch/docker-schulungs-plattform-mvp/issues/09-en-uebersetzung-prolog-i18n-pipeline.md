# 09: EN-Übersetzung Prolog + i18n-Pipeline validiert

**What to build:** Modul 0 auf Englisch als vollständige Übersetzung. Beweist, dass die Starlight-i18n-Pipeline für spätere Übersetzungen funktioniert, ohne dass wir vor dem ersten Kunden den gesamten EN-Track pflegen müssen. Der Sprach-Umschalter wechselt sauber zwischen DE und EN, gerenderte Seiten haben stabile Slugs und interne Links passen sich sprachabhängig an.

**Blocked by:** 03

**Status:** ready-for-agent

- [ ] Englische Fassung von Modul 0 in `site/src/content/docs/en/prolog/00-setup.md`, inhaltlich äquivalent zur DE-Version zum Zeitpunkt der Übersetzung
- [ ] Plattform-Vokabular in der Übersetzung: Modul → Module, Lab bleibt Lab, Flag bleibt Flag, Verifier bleibt Verifier — konsistent mit ADR-0002
- [ ] Fach-Vokabular (Image, Container, Volume, Registry, Docker Desktop, Rancher Desktop) bleibt englisch — passt automatisch
- [ ] Sprach-Umschalter in der Navigation wechselt zwischen DE- und EN-Fassung derselben Seite (nicht zu einer leeren Root-Seite)
- [ ] CI-Job `content-schema` prüft Frontmatter für beide Sprachen
- [ ] Falls in EN eine Seite fehlt, für die DE eine Version hat: Starlight zeigt einen sauberen „nicht übersetzt"-Hinweis statt Broken-Link (Feature-Lag akzeptiert per ADR-0002)
- [ ] Autor-README dokumentiert kurz den Übersetzungs-Workflow für spätere Module
