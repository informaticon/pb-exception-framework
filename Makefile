SHELL := pwsh.exe
.SHELLFLAGS := -Command

.PHONY: build
build:
	act -P windows-latest=-self-hosted -W .github/workflows/release.yml --artifact-server-path ./build