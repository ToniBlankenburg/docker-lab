# Cloud-Schulung – Plattform

Domänen-Sprache der Schulungsplattform, auf der interaktive Cloud-Schulungen für Software-Entwickler entstehen. Fokus des Repos ist zuerst das Docker-Modul-Set; die Struktur ist so gebaut, dass Kubernetes, CI/CD und weitere Modul-Sets später danebengelegt werden können.

## Sprache

### Struktur der Inhalte

**Kurs**:
Zusammenstellung von Modulen zu einem Themenbogen für eine bestimmte Zielgruppe (z. B. „Cloud-Schulung für Junior-Devs"). Ein Kurs kann Module aus mehreren Themenfeldern kombinieren.
_Vermeide_: Schulung, Curriculum, Track

**Modul**:
Eine in sich geschlossene Lerneinheit von 1–1,5 Stunden aus **Erklärung** und einem **Lab**. Deckt genau ein Konzept ab. Ist entweder ein Kern-Modul oder ein Vertiefungs-Modul.
_Vermeide_: Lektion, Kapitel, Unit

**Kern-Modul**:
Pflicht-Modul, das in fester linearer Reihenfolge absolviert wird. Baut auf den vorigen Kern-Modulen auf.
_Vermeide_: Pflichtmodul, Basismodul

**Vertiefungs-Modul**:
Optionales Modul, das nach den Kern-Modulen in beliebiger Reihenfolge absolviert werden kann. Setzt den Abschluss aller Kern-Module voraus.
_Vermeide_: Wahlmodul, Bonus-Modul, Advanced-Modul

### Praktische Übungen

**Lab**:
Die praktische Übung eines Moduls. Genau ein Lab pro Modul. Immer mit prüfbarem Erfolg über eine Flag.
_Vermeide_: Übung, Exercise, Task, Challenge

**Flag**:
Der objektive, maschinell prüfbare Beweis, dass ein Lab gelöst wurde. Format: `FLAG{<beschreibender-slug>}`. Wird vom Verifier ausgegeben, nicht vom Teilnehmer geraten oder eingegeben.
_Vermeide_: Token, Beweis, Solution-Key

**Verifier**:
Container-Image pro Lab (`docker-schulung/verify-lab-NN`), das den Zielzustand des Teilnehmer-Setups prüft. Gibt bei Erfolg die Flag aus und schreibt den Eintrag in die Fortschrittsdatei.
_Vermeide_: Checker, Validator, Grader

### Fortschritt

**Fortschrittsdatei**:
JSON-Datei unter `~/.docker-schulung/progress.json`, in die Verifier gelöste Labs eintragen. Einzige Quelle des Fortschritts eines Teilnehmers; wird nicht zentral gespeichert oder synchronisiert.
_Vermeide_: State-File, Progress-Store

### Rollen

**Teilnehmer**:
Person, die den Kurs absolviert. Führt alle Labs lokal auf dem eigenen Rechner aus (Docker Desktop oder Rancher Desktop).
_Vermeide_: Lernender, Student, User

**Autor**:
Person, die Module und Labs im Repo erstellt und pflegt. Nicht identisch mit dem Trainer, der optionale Live-Q&A-Slots leitet.
_Vermeide_: Trainer (nur für Live-Q&A), Kursleiter
