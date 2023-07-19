COMMIT_ID_LONG=$(shell git rev-parse HEAD)

.PHONY: tidy
tidy:
	go mod tidy
	git diff --exit-code


.PHONY: fmt
fmt: install.gofumpt
	# -l: list files whose formatting differs from gofumpt's
	# -w: write results to source files instead of stdout
	${GOFUMPT} -l -w . 
	git diff --exit-code


.PHONY: bin
bin:
	CGO_ENABLED=0 go build \
		-ldflags "-X 'github.com/mgoerens/test-github-actions/cmd.CommitIDLong=$(COMMIT_ID_LONG)'" \
		-o ./out/test-github-actions main.go

.PHONY: lint
lint: install.golangci-lint
	$(GOLANGCI_LINT) run


# gofumpt
GOFUMPT = $(shell pwd)/out/gofumpt
install.gofumpt:
	$(call go-install-tool,$(GOFUMPT),mvdan.cc/gofumpt@latest)

# golangci-lint
GOLANGCI_LINT = $(shell pwd)/out/golangci-lint
GOLANGCI_LINT_VERSION ?= v1.52.2
install.golangci-lint: $(GOLANGCI_LINT)
$(GOLANGCI_LINT):
	$(call go-install-tool,$(GOLANGCI_LINT),github.com/golangci/golangci-lint/cmd/golangci-lint@$(GOLANGCI_LINT_VERSION))\


# go-install-tool will 'go install' any package $2 and install it to $1.
PROJECT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
define go-install-tool
@[ -f $(1) ] || { \
GOBIN=$(PROJECT_DIR)/out go install $(2) ;\
}
endef
