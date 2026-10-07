# Commit-Artefakte

Nach einem Push auf `main` oder `master` den Workflow `Release Artifact` öffnen und das Actions-Artefakt herunterladen.
Es enthält das ZIP `hive-BRANCH-KURZSHA.zip` und `RELEASE_NOTES.md` mit Repository, Branch, Commit,
Event, Actor, UTC-Zeitpunkt und letzten Commits beziehungsweise Änderungen seit dem vorherigen Tag.
Die ZIP hat `hive/` als Wurzel und enthält nur versionierte Dateien, keine Git-Daten oder lokalen Caches.
Der Kurz-SHA-Teil hat zwölf Zeichen; Branch-Namen werden für Dateinamen normalisiert.

Es werden keine Tags und keine GitHub Releases automatisch angelegt. Eine verbindliche Release-Strategie ist nicht festgelegt.
