# LaTeX: Zusammenfassungen und Spickzettel

Jedes Modul hat zwei getrennte Dokumente:

```
<MODUL>/
├── zusammenfassung/
│   ├── <modul>-zusammenfassung.tex   Hauptdatei: Titel, Inhaltsverzeichnis, bindet die Kapitel ein
│   ├── kapitel/                      ein Kapitel pro Woche/Serie (Wochenziele, Kernideen, Beispiele …)
│   └── bilder/                       Grafiken, eingebunden mit \includegraphics{name}
└── spickzettel/
    └── <modul>-spickzettel.tex       Querformat, 3 Spalten, 8 pt: nur Formeln, Verfahren, Fallen
```

`praeambel.tex` in diesem Ordner gilt für alle Dokumente. Wer dort eine Farbe oder Box ändert,
ändert sie überall.

## Bausteine

```latex
\begin{wochenziele}
  \ziel{Lernpunkt}{Lernziel}            % Nummer wird automatisch gezählt
\end{wochenziele}

\begin{definition}{Heap} ... \end{definition}
\begin{merke} ... \end{merke}
\begin{beispiel}{insert(5)} ... \end{beispiel}
\begin{pruefung} ... \end{pruefung}      % Prüfungstipp

\Oh{n^2}                                 % O-Notation
\begin{lstlisting}[language=Python] ... \end{lstlisting}
```

Bäume (BST, Heap, AVL) mit `forest`:

```latex
\begin{forest}
  for tree={circle, draw, minimum size=6mm}
  [6 [2 [1] [4]] [9 [8] [,phantom]]]
\end{forest}
```

## Kompilieren

In VS Code die Hauptdatei öffnen und speichern (Strg+S): LaTeX Workshop baut das PDF
automatisch in den Unterordner `build/`. Vorschau: Strg+Alt+V.

Im Terminal: `latexmk -pdf -outdir=build ads-zusammenfassung.tex`
