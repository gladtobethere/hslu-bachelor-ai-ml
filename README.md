# hslu-bachelor-ai-ml

Eigene Übungen zum Bachelor AI/ML an der HSLU: Algorithmen, Datenstrukturen,
Lineare Algebra und diskrete Mathematik. Alles hier ist selbst geschrieben;
Unterlagen der Dozierenden liegen nicht in diesem Repository.

## Aufbau

```
2026-FA/
├── _latex/       gemeinsame LaTeX-Präambel und Anleitung
├── ADS/          zusammenfassung/ + spickzettel/
├── LIAL/         zusammenfassung/ + spickzettel/
├── DMATH-ALGO/   zusammenfassung/ + spickzettel/
└── DMATH-CODE/   zusammenfassung/ + spickzettel/

practice/
├── ads/          Algorithmen & Datenstrukturen
├── lial/         Lineare Algebra
├── dmath-algo/   Diskrete Mathematik: Logik, Beweise, Zählen, Graphen
├── dmath-code/   Diskrete Mathematik: Wahrscheinlichkeit
├── journal/      kurzer Lerneintrag pro Abend
└── _vorlagen/    Vorlagen für neue Aufgaben und Notebooks
```

Die Zusammenfassungen sind in LaTeX geschrieben: ein Kapitel pro Woche mit Wochenzielen,
Kernideen, Beispielen und Prüfungstipps. Der Spickzettel ist bewusst kurz (Querformat, drei Spalten)
und enthält nur Formeln, Verfahren und typische Fallen. Anleitung: [`2026-FA/_latex/README.md`](2026-FA/_latex/README.md).

Für Git und GitHub gibt es ein eigenes Nachschlagewerk in LaTeX:
[`docs/git-handbuch/git-handbuch.tex`](docs/git-handbuch/git-handbuch.tex), ein Kapitel pro Datei in `kapitel/`.

## Arbeitsweise

- Eine Datei pro Aufgabe, Name mit Quelle und Nummer, z. B. `leetcode/0020_valid_parentheses.py`.
- Jede Lösung enthält eigene Tests (`assert`), damit sofort sichtbar ist, ob sie stimmt.
- Mathe zuerst von Hand rechnen, danach im Notebook mit NumPy kontrollieren.
- Pro Abend ein eigener Branch, danach Pull Request und Merge in `main`.

## Einrichten

Auf jedem neuen Windows-PC einmal im Repo-Ordner ausführen (installiert LaTeX, Perl und die
VS-Code-Erweiterungen, mehrfach ausführbar):

```bash
powershell -ExecutionPolicy Bypass -File setup\einrichten.ps1
```

Danach VS Code ganz schliessen und neu öffnen. Die Editor-Einstellungen liegen in `.vscode/`
und kommen mit Git automatisch auf jedes Gerät.

Python-Umgebung:

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

## Wochenrhythmus

| Tag | Modul |
|-----|-------|
| Mo  | ADS |
| Di  | Lineare Algebra |
| Mi  | DMATH Algorithmen |
| Do  | DMATH Code |
| Fr  | schwächstes Modul der Woche |
| Wochenende | eine alte Prüfung auf Papier, mit Zeitlimit |

## Fortschritt

| Modul | Gelöste Aufgaben | Zuletzt |
|-------|-----------------:|---------|
| ADS | 0 | – |
| LIAL | 0 | – |
| DMATH Algorithmen | 0 | – |
| DMATH Code | 0 | – |
