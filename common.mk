TRVS ?= trvs
TOP := $(shell git rev-parse --show-toplevel)

.PHONY: apply
apply: .secrets
	kubectl apply -f secrets/
	kubectl apply -f .

