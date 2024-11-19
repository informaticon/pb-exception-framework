.PHONY=clean build
SHELL := cmd.exe

PB_RUNTIME ?= 25.0.0.3453
PLATFORM ?= x86

PB_MAJOR := $(basename $(basename $(basename $(PB_RUNTIME))))
TARGET := pb$(PB_MAJOR)$(PLATFORM)

build: build/out/$(TARGET)/exf1.pbd build/out/$(TARGET)/exf1.dll

tests: build/out/$(TARGET)/exf1.dll
	if not exist "build/tests/$(TARGET)" mkdir "build/tests/$(TARGET)"
	.\scripts\build_tests.bat $(PB_RUNTIME) $(PLATFORM) build/tests/$(TARGET) build/tests/$(TARGET)
	xcopy /s /y build\out\$(TARGET)\exf1.dll build\tests\$(TARGET)
	.\build\tests\$(TARGET)\test_exf.exe --run-all --quiet

analyzer: build/out/$(TARGET)/exf1.dll
	if not exist "build/analyzer/$(TARGET)" mkdir "build/analyzer/$(TARGET)"
	.\scripts\build_analyzer.bat $(PB_RUNTIME) $(PLATFORM) build/analyzer/$(TARGET) build/analyzer/$(TARGET)
	xcopy /s /y build\out\$(TARGET)\exf1.dll build\analyzer\$(TARGET)

build/out/$(TARGET)/exf1.dll:
	.\scripts\build_dll.bat $(PB_RUNTIME) $(PLATFORM) build/out/$(TARGET) build/dll/$(TARGET)

build/out/$(TARGET)/exf1.pbd: build/demo/$(TARGET)
	xcopy /s /y build\demo\$(TARGET)\exf1.pbd build\out\$(TARGET)

build/demo/$(TARGET): build/out/$(TARGET)/exf1.dll
	if not exist "build/demo/$(TARGET)" mkdir "build/demo/$(TARGET)"
	.\scripts\build_demo.bat $(PB_RUNTIME) $(PLATFORM) build/demo/$(TARGET) build/demo/$(TARGET)
	xcopy /s /y build\out\$(TARGET)\exf1.dll build\demo\$(TARGET)

clean:
	if exist "build/out" rmdir /s /q "build/out"
	if exist "build/dll" rmdir /s /q "build/dll"
	if exist "build/demo" rmdir /s /q "build/demo"
	if exist "build/analyzer" rmdir /s /q "build/analyzer"
	if exist "build/tests" rmdir /s /q "build/tests"
