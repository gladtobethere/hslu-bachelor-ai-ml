<#
  Richtet einen Windows-PC fuer dieses Repository ein.
  Mehrfach ausfuehrbar: Was schon vorhanden ist, wird uebersprungen.

  Aufruf (im Repo-Ordner):
      powershell -ExecutionPolicy Bypass -File setup\einrichten.ps1

  Macht:
    1. LaTeX (MiKTeX) und Perl (fuer latexmk) installieren
    2. MiKTeX so einstellen, dass fehlende Pakete automatisch nachgeladen werden
       und die Python-Umgebung .venv (fuer Code und Notebooks) anlegen
    3. die VS-Code-Erweiterungen aus .vscode\extensions.json installieren
    4. pruefen, ob gh (GitHub CLI) angemeldet ist
    5. alle LaTeX-Dokumente einmal testweise bauen
#>

# 'Continue' statt 'Stop': Windows PowerShell 5.1 bricht sonst ab, sobald ein Programm
# (winget, gh, latexmk) Hinweise auf den Fehlerkanal schreibt, auch wenn alles klappt.
$ErrorActionPreference = 'Continue'
$repo = Split-Path -Parent $PSScriptRoot

function Schritt([string]$text) { Write-Host "`n== $text" -ForegroundColor Cyan }
function Ok([string]$text)      { Write-Host "   OK  $text" -ForegroundColor Green }
function Info([string]$text)    { Write-Host "   ..  $text" }
function Warnung([string]$text) { Write-Host "   !!  $text" -ForegroundColor Yellow }

# Nach einer Installation kennt diese Konsole den neuen PATH noch nicht: neu einlesen.
function PfadNeuLaden {
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
                [Environment]::GetEnvironmentVariable('Path', 'User')
}

function Installiere([string]$wingetId, [string]$name, [string]$programm) {
    PfadNeuLaden
    if (Get-Command $programm -ErrorAction SilentlyContinue) { Ok "$name ist installiert"; return }
    Info "$name wird installiert (winget: $wingetId) ..."
    winget install --id $wingetId --exact --silent --accept-package-agreements --accept-source-agreements
    PfadNeuLaden
    if (Get-Command $programm -ErrorAction SilentlyContinue) { Ok "$name installiert" }
    else { Warnung "$($name): '$programm' nicht gefunden. Konsole neu oeffnen und Skript nochmals starten." }
}

# ---------------------------------------------------------------------
Schritt "1. Programme"
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget fehlt. Im Microsoft Store 'App Installer' installieren und Skript erneut starten."
}
Installiere 'MiKTeX.MiKTeX'                 'MiKTeX (LaTeX)' 'pdflatex'
Installiere 'StrawberryPerl.StrawberryPerl' 'Strawberry Perl' 'perl'

# ---------------------------------------------------------------------
Schritt "2. MiKTeX einstellen"
if (Get-Command initexmf -ErrorAction SilentlyContinue) {
    initexmf --set-config-value "[MPM]AutoInstall=1"
    Ok "fehlende LaTeX-Pakete werden automatisch nachgeladen"
} else { Warnung "initexmf nicht gefunden, Schritt uebersprungen" }

# ---------------------------------------------------------------------
Schritt "2b. Python-Umgebung (.venv) fuer Code und Jupyter-Notebooks"
$venvPy = Join-Path $repo '.venv\Scripts\python.exe'
if (-not (Test-Path $venvPy)) {
    if (Get-Command py -ErrorAction SilentlyContinue) { py -3.12 -m venv (Join-Path $repo '.venv') }
    else { python -m venv (Join-Path $repo '.venv') }
}
if (Test-Path $venvPy) {
    & $venvPy -m pip install --quiet --upgrade pip
    & $venvPy -m pip install --quiet -r (Join-Path $repo 'requirements.txt')
    Ok ".venv bereit (Pakete aus requirements.txt)"
} else { Warnung "Python nicht gefunden. Python 3.12 installieren: winget install --id Python.Python.3.12" }

# ---------------------------------------------------------------------
Schritt "3. VS-Code-Erweiterungen"
if (Get-Command code -ErrorAction SilentlyContinue) {
    $json = Get-Content (Join-Path $repo '.vscode\extensions.json') -Raw
    $json = ($json -split "`n" | Where-Object { $_ -notmatch '^\s*//' }) -join "`n"   # Kommentare entfernen
    $vorhanden = @(code --list-extensions) | ForEach-Object { $_.ToLower() }
    foreach ($ext in ($json | ConvertFrom-Json).recommendations) {
        if ($vorhanden -contains $ext.ToLower()) { Ok $ext }
        else { Info "installiere $ext"; code --install-extension $ext | Out-Null; Ok $ext }
    }
} else { Warnung "VS Code ('code') nicht gefunden. VS Code installieren und Skript erneut starten." }

# ---------------------------------------------------------------------
Schritt "4. GitHub CLI"
if (Get-Command gh -ErrorAction SilentlyContinue) {
    gh auth status *> $null
    if ($LASTEXITCODE -eq 0) { Ok "gh ist angemeldet" }
    else { Warnung "gh ist nicht angemeldet. Ausfuehren: gh auth login --hostname github.com --git-protocol https --web" }
} else { Info "gh nicht installiert (optional): winget install --id GitHub.cli" }

# ---------------------------------------------------------------------
Schritt "5. LaTeX-Test"
$dokumente = Get-ChildItem $repo -Recurse -Include '*-zusammenfassung.tex', '*-spickzettel.tex', 'git-handbuch.tex' |
             Where-Object { $_.FullName -notmatch '\\build\\' }
foreach ($d in $dokumente) {
    Push-Location $d.DirectoryName
    latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build $d.Name *> $null
    if ($LASTEXITCODE -eq 0) { Ok $d.Name } else { Warnung "$($d.Name) laesst sich nicht bauen, siehe build\$($d.BaseName).log" }
    Pop-Location
}

Write-Host "`nFertig. Wichtig: VS Code jetzt ganz schliessen und ueber das Startmenue neu oeffnen," -ForegroundColor Cyan
Write-Host "damit es die neu installierten Programme findet." -ForegroundColor Cyan
