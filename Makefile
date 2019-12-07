DIST ?= fc31
VERSION := $(shell cat version)
REL := $(shell cat rel)

SRC_RPM := kobo-$(VERSION)-$(REL).$(DIST).src.rpm
SRC_FILE := kobo-$(VERSION).tar.gz

BUILDER_DIR ?= ../..
SRC_DIR ?= qubes-src
UNTRUSTED_SUFF := .UNTRUSTED
FETCH_CMD := $(BUILDER_DIR)/$(SRC_DIR)/builder-rpm/scripts/get_sources_from_srpm

SHELL := /bin/bash

%: %.sha512 %$(UNTRUSTED_SUFF)
	@sha512sum --status -c <(printf "$$(cat $<)  -\n") <$@$(UNTRUSTED_SUFF) || \
		{ echo "Wrong SHA512 checksum on $@$(UNTRUSTED_SUFF)!"; exit 1; }
	@mv $@$(UNTRUSTED_SUFF) $@

$(SRC_FILE:%=%$(UNTRUSTED_SUFF)):
	@$(FETCH_CMD) $(DIST) $(SRC_RPM) $(SRC_FILE)

.PHONY: get-sources
get-sources: $(SRC_FILE)

.PHONY: verify-sources
verify-sources:
	@true
