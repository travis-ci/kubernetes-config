include $(shell git rev-parse --show-toplevel)/common.mk

MAKE_SECRET ?= $(TOP)/bin/make-secret

SECRETS_FILES := \
	secrets/worker-org.yaml \
	secrets/jupiter-brain-org.yaml

.PHONY: clean
clean:
	rm -rf secrets/

.PHONY: .secrets
.secrets: $(SECRETS_FILES)

secrets/worker-org.yaml:
	mkdir -p secrets
	$(TRVS) generate-config -f yaml macstadium-workers staging-common | $(MAKE_SECRET) -n worker-org -p TRAVIS_WORKER > $@

secrets/jupiter-brain-org.yaml:
	mkdir -p secrets
	$(TRVS) generate-config -f yaml jupiter-brain staging-1 | $(MAKE_SECRET) -n jupiter-brain-org -p JUPITER_BRAIN > $@
