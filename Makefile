# ======== Config ========
PY  := .venv/bin/python
PIP := .venv/bin/pip
KERNEL := health_claims_ml
NB_INGEST := notebooks/01_ingest_eda.ipynb

# ======== Bootstrap ========
.venv:
	python3 -m venv .venv

install: .venv
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements-dev.txt
	$(PY) -m ipykernel install --user --name $(KERNEL) --display-name "Python ($(KERNEL))"
	@echo "✔ Installed. Select kernel: Python ($(KERNEL))"

# ======== Quality ========
format:
	.venv/bin/isort src tests || true
	.venv/bin/black src tests || true

lint:
	.venv/bin/pylint --disable=R,C src || true

lint-fast:
	.venv/bin/ruff check src tests || true

test:
	.venv/bin/pytest -vv

nb-check:
	.venv/bin/papermill $(NB_INGEST) /tmp/01_ingest_eda.out.ipynb

# ======== Meta ========
all: install lint test
	@echo "✔ all done"

clean:
	rm -rf __pycache__ .pytest_cache .ruff_cache .ipynb_checkpoints

reset: clean
	rm -rf .venv

.PHONY: install format lint lint-fast test nb-check all clean reset
