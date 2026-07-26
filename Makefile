SHELL := /usr/bin/env bash

UV := $(shell command -v uv 2>/dev/null || printf '%s/.local/bin/uv' "$$HOME")
PYTHON := .venv/bin/python
APP := main.py

.PHONY: setup install-uv run clean reset

setup: install-uv
	@echo "Installing Python..."
	@$(UV) python install

	@echo "Creating virtual environment..."
	@$(UV) venv

	@echo "Installing dependencies..."
	@$(UV) pip install \
		--python $(PYTHON) \
		-r requirements.txt

	@echo "Project ready."

install-uv:
	@if command -v uv >/dev/null 2>&1; then \
		echo "uv is already installed."; \
	elif [[ -x "$(HOME)/.local/bin/uv" ]]; then \
		echo "uv is already installed."; \
	else \
		command -v curl >/dev/null 2>&1 || { \
			echo "ERROR: curl is required."; \
			exit 1; \
		}; \
		echo "Installing uv..."; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
	fi

run:
	@test -x "$(PYTHON)" || { \
		echo "ERROR: Run 'make setup' first."; \
		exit 1; \
	}
	@$(PYTHON) $(APP)

clean:
	@rm -rf .venv

reset: clean setup