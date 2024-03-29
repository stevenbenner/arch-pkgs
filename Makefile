SHELL = /bin/bash

REPO_DIR := ./repo
TARGET_REPO := private

ifeq (, $(shell which shellcheck))
$(error "Failed! Could not find shellcheck.")
endif

ifeq (, $(shell which namcap))
$(error "Failed! Could not find namcap.")
endif

$(REPO_DIR): system-config
	@echo "Updating $(TARGET_REPO) package repo..."
	mkdir --parents $@
	repo-add $(REPO_DIR)/$(TARGET_REPO).db.tar.gz pkg/**/*.pkg.tar.zst
	rm --force --verbose $(REPO_DIR)/$(TARGET_REPO).{db,files}
	cp $(REPO_DIR)/$(TARGET_REPO).db.tar.gz $(REPO_DIR)/$(TARGET_REPO).db
	cp $(REPO_DIR)/$(TARGET_REPO).files.tar.gz $(REPO_DIR)/$(TARGET_REPO).files
	cp pkg/**/*.pkg.tar.zst $@

system-config:
	@echo "Building $@ package..."
	cd pkg/system-config; makepkg

.PHONY: check
check:
	@echo "Running shellcheck on files..."
	shellcheck --shell=bash --exclude=SC2034,SC2154 pkg/**/PKGBUILD
	shellcheck --shell=bash pkg/**/*.install
	@echo "Running namcap on files..."
	namcap --info --exclude=splitpkgmakedeps pkg/**/PKGBUILD

.PHONY: clean
clean:
	@echo "Removing build artifacts..."
	rm --recursive --force --verbose pkg/**/{pkg,src,*.pkg.tar.zst,*.pkg.tar.zst.sig}
