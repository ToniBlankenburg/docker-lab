# 0002 – Deutsch als Primary, Englisch als spätere Übersetzung

Alle Schulungsinhalte werden zuerst und vollständig auf Deutsch verfasst. Englische Fassungen entstehen später als Übersetzung und dürfen einen Feature-Lag haben.

Grund: Die Erst-Zielgruppe ist deutschsprachig; ein voll gepflegter EN-Track vor dem ersten Kunden wäre Doppelarbeit ohne Nachfrage. Konsequenz: Starlight (ADR-0001) wird von Anfang an i18n-fähig konfiguriert – die Ordnerstruktur unterscheidet bereits jetzt zwischen `de/` und `en/`, damit die Übersetzung später ein reiner Content-Diff ist, kein Umbau.

Fach-Vokabular (Image, Container, Volume, Registry, …) bleibt in beiden Sprachen englisch. Das Plattform-Vokabular (Modul, Lab, Flag, Verifier – siehe CONTEXT.md) wird in DE deutsch, in EN wörtlich übernommen (Modul → Module, Lab bleibt Lab, Flag bleibt Flag, Verifier bleibt Verifier).

Falls sich die Kundenlage in Richtung international verschiebt, wird die Umkehr auf EN-Primary bewusst per neuer ADR beschlossen und der Übersetzungs-Aufwand einmalig getragen.
