include $(shell git rev-parse --show-toplevel)/common.mk

MAKE_SECRET ?= $(TOP)/bin/make-secret

SECRETS_FILES := \
	secrets/worker-org.yaml \
	secrets/worker-com.yaml \
	secrets/jupiter-brain-org.yaml \
	secrets/jupiter-brain-com.yaml \
	secrets/vsphere-monitor.yaml \
	secrets/travis-vm-ssh-key.yaml

.PHONY: clean
clean:
	rm -rf secrets/

.PHONY: .secrets
.secrets: $(SECRETS_FILES)

secrets/worker-org.yaml:
	mkdir -p secrets
	$(TRVS) generate-config -f yaml macstadium-workers staging-common | $(MAKE_SECRET) -n worker-org -p TRAVIS_WORKER > $@

secrets/worker-com.yaml:
	mkdir -p secrets
	$(TRVS) generate-config --pro -f yaml macstadium-workers staging-common | $(MAKE_SECRET) -n worker-com -p TRAVIS_WORKER > $@

secrets/jupiter-brain-org.yaml:
	mkdir -p secrets
	$(TRVS) generate-config -f yaml jupiter-brain staging-1 | $(MAKE_SECRET) -n jupiter-brain-org -p JUPITER_BRAIN > $@

secrets/jupiter-brain-com.yaml:
	mkdir -p secrets
	$(TRVS) generate-config --pro -f yaml jupiter-brain staging-1 | $(MAKE_SECRET) -n jupiter-brain-com -p JUPITER_BRAIN > $@

secrets/vsphere-monitor.yaml:
	mkdir -p secrets
	$(TRVS) generate-config -f yaml vsphere-monitor common-1 | $(MAKE_SECRET) -n vsphere-monitor -p VSPHERE_MONITOR > $@

secrets/travis-vm-ssh-key.yaml:
	mkdir -p secrets
	$(MAKE_SECRET) -n travis-vm-ssh-key -k travis-vm-ssh-key $$TRAVIS_KEYCHAIN_DIR/travis-keychain/macstadium/travis-vm-ssh-key > $@
