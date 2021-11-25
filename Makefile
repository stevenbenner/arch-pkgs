SHELL = /bin/bash

REPO_DIR := ./repo
TARGET_REPO := private

ifeq (, $(shell which shellcheck))
$(error "Failed! Could not find shellcheck.")
endif

$(REPO_DIR): system-config
	@echo "Updating $(TARGET_REPO) package repo..."
	mkdir -p $@
	repo-add $(REPO_DIR)/$(TARGET_REPO).db.tar.gz pkg/**/*.pkg.tar.zst
	cp pkg/**/*.pkg.tar.zst $@

system-config:
	@echo "Building $@ package..."
	cd pkg/system-config; makepkg

.PHONY: check
check:
	@echo "Running shellcheck on files..."
	shellcheck -e SC2034 -e SC2148 -e SC2154 pkg/**/PKGBUILD
	shellcheck -e SC2148 pkg/**/*.install

.PHONY: clean
clean:
	@echo "Removing build artifacts..."
	rm -rfv pkg/**/{pkg,src,*.pkg.tar.zst,*.pkg.tar.zst.sig}
