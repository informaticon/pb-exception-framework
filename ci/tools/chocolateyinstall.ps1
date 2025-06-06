$ErrorActionPreference = "Stop"

$toolsDir        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$programFolder   = Join-Path $env:ChocolateyInstall "lib" | Join-Path -ChildPath $env:ChocolateyPackageName
$startMenuFolder = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs"

$zipFile         = Join-Path $toolsDir "exf_analyzer.zip"
$shortcutPath    = Join-Path $startMenuFolder "EXFAnalyzer.lnk"
$exePath         = Join-Path $programFolder "exf_analyzer.exe"
$logoPath        = Join-Path $programFolder "exf_analyzer.ico"

Write-Output ("Install " + $env:ChocolateyPackageName + " to " + $programFolder)
$packageArgs = @{
  PackageName  = $env:ChocolateyPackageName
  Destination  = $programFolder
  FileFullPath = $zipFile
}
Get-ChocolateyUnzip @packageArgs

$shortcutArgs = @{
  ShortcutFilePath = $shortcutPath
  TargetPath       = $exePath
  IconLocation     = $logoPath
  WorkingDirectory = $programFolder
}
Install-ChocolateyShortcut @shortcutArgs

