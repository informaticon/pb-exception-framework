$ErrorActionPreference = "Stop"

$startMenuFolder = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs"
$shortcutPath    = Join-Path $startMenuFolder "EXFAnalyzer.lnk"

if (Test-Path $shortcutPath) {
	Remove-Item -Path $shortcutPath
}
