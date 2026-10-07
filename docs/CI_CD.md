# CI und Commit-Artefakte

`CI` führt `python tools/check_project.py` bei Pull Requests und Pushes auf `main` oder `master` sowie manuell aus.
Welche Grenzen die Prüfung hat, steht in README.md. Es werden keine Systemänderungen oder Makros ausgeführt.

`Release Artifact` erstellt bei jedem Push auf `main` oder `master` ein ZIP des Commits mit `git archive`
und Commit-Notizen. Die Workflows benötigen nur `contents: read`; verwendete Actions sind auf Commit-SHAs fixiert.
Dependabot prüft die tatsächlich verwendeten GitHub Actions monatlich.
Es sind keine Docker-Builds, GHCR-Images oder zusätzlichen Registry-Secrets eingerichtet.
