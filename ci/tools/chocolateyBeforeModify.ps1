
$startMenuFolder = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs"
$deprecatedShortcutPath    = Join-Path $startMenuFolder "EXFAnalyzer.lnk"

if (Test-Path $deprecatedShortcutPath) {
	Remove-Item -Path $deprecatedShortcutPath
}
