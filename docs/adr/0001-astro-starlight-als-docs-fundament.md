# 0001 – Astro Starlight als Docs-Fundament

Die Schulungsinhalte werden mit **Astro Starlight** als statischem Site-Generator gebaut. Alternativen waren Docusaurus 3 und MkDocs Material.

Ausschlag gaben: (1) i18n out-of-the-box für DE-Primary / EN-Übersetzung (siehe ADR-0002), (2) minimaler Build-Overhead und einfacher Betrieb auf GitHub Pages / Cloudflare Pages, (3) leichtgewichtiger Stack ohne React-Pflicht – passt zur Markdown-first-Content-Strategie ohne interaktive Playgrounds im MVP.

Docusaurus bleibt der ausdrückliche Fallback, falls wir später React-basierte Widgets (interaktive Playgrounds, komplexe Diagramm-Komponenten) brauchen – in dem Fall eine Migration in Kauf nehmen und per neuer ADR beschließen.
