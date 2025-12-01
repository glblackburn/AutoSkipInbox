SHELL=/bin/bash
.EXPORT_ALL_VARIABLES:
.SHELLFLAGS = -uec -o pipefail

PYTHON ?= python3
PIP ?= pip3
VENV_DIR ?= venv
VENV_PYTHON = $(VENV_DIR)/bin/python
VENV_PIP = $(VENV_DIR)/bin/pip

default: help

venv: ## create a Python virtual environment
	$(PYTHON) -m venv $(VENV_DIR)
	$(VENV_PIP) install --upgrade pip

install: ## install Python dependencies
	$(PIP) install -r requirements.txt

install-venv: venv ## create venv and install dependencies in it
	$(VENV_PIP) install -r requirements.txt

setup: install ## setup the system to run this application (alias for install)

run: ## run the AutoSkipInbox
	$(PYTHON) autoskipinbox.py

run-venv: install-venv ## run using virtual environment
	$(VENV_PYTHON) autoskipinbox.py

run-tofix: ## run get_tofix_from.py
	$(PYTHON) get_tofix_from.py

run-todump: ## run get_todump_from.py
	$(PYTHON) get_todump_from.py

run-filters: ## run get_filters.py
	$(PYTHON) get_filters.py

run-label-report: ## run get_label_report.py
	$(PYTHON) get_label_report.py

test: ## test that Python and dependencies are available
	@echo "Checking Python version..."
	@$(PYTHON) --version
	@echo "Checking required packages..."
	@$(PYTHON) -c "import google.auth; import googleapiclient; print('✓ All dependencies available')" || (echo "✗ Missing dependencies. Run 'make install' or 'make install-venv'" && exit 1)

clean: ## remove virtual environment and cache files
	rm -rf $(VENV_DIR)
	find . -type d -name __pycache__ -exec rm -r {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete

.PHONY: help
help:
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
