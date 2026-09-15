# 0003 – Pro-Lab-Verifier mit Kombi-Probing

Jedes Lab hat einen **eigenen kleinen Verifier-Container** (`docker-schulung/verify-lab-NN`) statt eines globalen Verifiers mit Subcommands. Vorteil: Verifier-Logik pro Lab isoliert und unabhängig versionierbar. Nachteil: mehr Images zu bauen und zu pflegen – bewusst akzeptiert.

Der Verifier prüft den Zielzustand des Teilnehmer-Setups **primär via Netzwerk-Probes** im gemeinsamen Docker-Netz (HTTP/TCP gegen den Ziel-Container). Für Labs, die Introspektion in Image-Layer, Volumes oder Netzwerke brauchen, wird der Docker-Socket in den Verifier gemountet – dort **explizit als in Produktion verbotenes Anti-Pattern gekennzeichnet und im Modul-Text besprochen**. Der didaktische Wert (Teilnehmer sehen die riskante Praxis früh und lernen, sie zu erkennen) überwiegt das Vorbild-Risiko.

Der Verifier ist auch die einzige Instanz, die in die Fortschrittsdatei (`~/.docker-schulung/progress.json`) schreibt. Es gibt bewusst **kein separates Progress-CLI** – der Verifier gibt bei Erfolg neben der Flag auch den aggregierten Stand aus (z. B. `✅ Lab 3 gelöst. Gesamt: 3 / 8`).
