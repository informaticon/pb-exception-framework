ifeq ($(OS),Windows_NT)
	SHELL := pwsh.exe
else
	SHELL := pwsh
endif
.SHELLFLAGS := -Command

.PHONY: build
build:
	act -P windows-latest=-self-hosted -W .github/workflows/release.yml --artifact-server-path ./build

.PHONY: backport
backport:
	@echo "####################################################################"
	@echo "# For backporting, you need to have the following tools installed: #"
	@echo "#  - PowerBuilder 2022R3 including pbc220.exe                      #"
	@echo "#   - pbmanager                                                    #"
	@echo "####################################################################"
	
	@echo ""
	@echo "## Prepare build environment"
	New-Item -ItemType Directory -Force -Path ./build/pb2022r3
	Copy-Item -Path "./ci/test/*" -Destination "./build/pb2022r3" -Recurse -Force
	
	@echo ""
	@echo "## Backport pb2025r1 code"
	pbmanager import -b ./build/pb2022r3 -t test_exf.pbt -p tst1,exf1,test_exf  ../../test ../..

	@echo ""
	@echo "## Compile using pb2022r3"
	pbc220.exe /d .\build\pb2022r3\test_exf.pbt

	@echo ""
	@echo "## Run tests"
	cmd.exe /c .\build\pb2022r3\test_exf.exe --run-all --quiet

.PHONY: test
test: backport
# tests have to be run by cmd.exe, because pwsh does not detect errors
	cmd.exe /c .\build\pb2022r3\test_exf.exe --run-all --quiet

.PHONY: clean
clean:
	Remove-Item -Recurse -Force .\build\
