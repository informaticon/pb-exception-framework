@echo off
::work_dir is not needed, but is there to be similar to build_dll.bat
set pb_runtime=%1
set bitness=%2
set out_dir=%3
set work_dir=%4
if %bitness%==x86 (
	set bitness=32
) else (
	set bitness=64
)

set base_dir=%cd%
set pb_version=%pb_runtime:~0,2%
set script_dir=%~dp0
set script_dir=%script_dir:~0,-1%

if not exist "%out_dir%" mkdir "%out_dir%"
if not exist "%work_dir%" mkdir "%work_dir%"

if %pb_version%==25 (
	PBautoBuild250.exe /pbc /d "%cd%\test\test_exf.pbproj" /f /x %bitness% /rt %pb_runtime% /o "%out_dir%\test_exf.exe"
	move "%base_dir%\exf1.pbd" "%out_dir%"
	move "%base_dir%\test\test_exf1.pbd" "%out_dir%"
	move "%base_dir%\test\tst1.pbd" "%out_dir%"
) else (
	xcopy /s /y "%script_dir%\test" "%out_dir%"
	pbmanager import -b "%out_dir%" -t test_exf.pbt -p exf1,test_exf1,tst1 "%base_dir%" "%base_dir%\test"
	pbc220 /d "%out_dir%\test_exf.pbt" /f /x %bitness% /rt %pb_runtime% /o "%out_dir%\test_exf.exe"
)