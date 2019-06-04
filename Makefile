package_name = datastore-viewer

export PATH := .venv/bin:$(shell echo ${PATH})

.PHONY: setup
setup:
	[ -d .venv ] || python3 -m venv .venv
	@echo "Please execute: make pip_compile"
	./.venv/bin/pip3 install --upgrade pip
	./.venv/bin/pip3 install --ignore-installed twine wheel pytest pip-tools

.PHONY: release
release: clean build
	python -m twine upload \
		--repository-url https://upload.pypi.org/legacy/ \
		dist/*

.PHONY: test_release
test_release: clean build
	python -m twine upload \
		--repository-url https://test.pypi.org/legacy/ \
		dist/*

.PHONY: test_install
test_install:
	pip --no-cache-dir install --upgrade \
		-i https://test.pypi.org/simple/ \
		${package_name}

.PHONY: build
build:
	python setup.py sdist bdist_wheel

.PHONY: clean
clean:
	rm -rf $(subst -,_,${package_name}).egg-info dist build

.PHONY: pip_compile
pip_compile:
	pip-compile \
		--output-file requirements.txt \
		requirements.in
	pip3 install --ignore-installed -r requirements.txt