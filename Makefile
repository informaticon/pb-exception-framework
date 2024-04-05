.PHONY: lib clean build
.ONESHELL:

SHELL := cmd.exe
PBruntimeFolder := C:\Program Files (x86)\Appeon\Common\PowerBuilder\Runtime 22.2.0.3289
VSDIR := C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC

cpp: FORCE
	for /F "delims=" %%i IN ('dir "$(VSDIR)" /b /ad-h /t:c /od') do set PATH=$(VSDIR)\%%i\bin\Hostx64\x86;%PATH%

	lib /def:cpp/lib/pbvm.def /out:cpp/lib/pbvm.lib /machine:x86
	lib /def:cpp/lib/pbshr.def /out:cpp/lib/pbshr.lib /machine:x86

	cmake cpp -B cpp\build --preset default
	cmake --build cpp\build --config MinSizeRel
	cmake --install cpp\build --config MinSizeRel

clean:
	rmdir /S /Q cpp\build
	del /S /Q cpp\lib\*.lib
	del /S /Q cpp\lib\*.exp
	del /S /Q exf1.dll
	del /S /Q *.pbl

FORCE: ;