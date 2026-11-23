TAGS ?=
COVERAGE_FILE := coverage.txt
# The installed golangci-lint cannot read Go 1.27 export data.
LINT_GO_TOOLCHAIN ?= go1.26.10

.PHONY: test
test:
	@echo "Running tests"
	@go test -tags "$(TAGS)" ./... -count=1

.PHONY: testrace
testrace:
	@echo "Running tests with race flag"
	@go test -tags "$(TAGS)" ./... -count=1 -race

.PHONY: integration
integration:
	@go test -tags "integration $(TAGS)" ./integration -count=1

.PHONY: coverage
coverage:
	@echo "Running tests with coverage"
	@go test -tags "$(TAGS)" ./... -covermode=atomic -coverprofile=$(COVERAGE_FILE) -count=1
	@go tool cover -func=$(COVERAGE_FILE)

.PHONY: lint
lint:
	@echo "Running code linters"
	@GOTOOLCHAIN=$(LINT_GO_TOOLCHAIN) golangci-lint run --build-tags tcf_example,integration --modules-download-mode readonly
