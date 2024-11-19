@echo off

::pb_runtime is not needed, but is there to be similar to build_demo.bat
set pb_runtime=%1
set bitness=%2
set out_dir=%3
set work_dir=%4

if "%bitness%"=="x86" (
	set platform=Win32
) else (
	echo "NOT SUPPORTET YET"
)
set base_dir=%cd%
set pb_version=%pb_runtime:~0,2%
set script_dir=%~dp0
set script_dir=%script_dir:~0,-1%

if "%MSVC_PATH%" == "" ( 
	set "MSVC_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC"
)

if not exist "%out_dir%" mkdir "%out_dir%"
if not exist "%work_dir%" mkdir "%work_dir%"

for /F "delims=" %%i IN ('dir "%MSVC_PATH%" /b /ad-h /t:c /od') do set "msvctools_path=%MSVC_PATH%\%%i\bin\Hostx64\%bitness%"
echo "%msvctools_path%"
"%msvctools_path%\lib.exe" /def:"%base_dir%\cpp\lib\pbvm.def" /out:"%work_dir%\pbvm.lib" /machine:%bitness%
"%msvctools_path%\lib.exe" /def:"%base_dir%\cpp\lib\pbshr.def" /out:"%work_dir%\pbshr.lib" /machine:%bitness%

cmake "%base_dir%\cpp" -B "%work_dir%" -D CMAKE_GENERATOR_PLATFORM=%platform% -D BITNESS=%bitness% -DCMAKE_INSTALL_PREFIX="%out_dir%"
cmake --build "%work_dir%" --config MinSizeRel
cmake --install "%work_dir%" --config MinSizeRel