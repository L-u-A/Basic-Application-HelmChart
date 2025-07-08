# Makefile for Basic Application Helm Chart

CHART_NAME := basic-application
NAMESPACE := default
RELEASE_NAME := my-app

# Default target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  install-dev    - Install chart with development values"
	@echo "  install-prod   - Install chart with production values"
	@echo "  upgrade-dev    - Upgrade chart with development values"
	@echo "  upgrade-prod   - Upgrade chart with production values"
	@echo "  uninstall      - Uninstall the chart"
	@echo "  lint           - Lint the chart"
	@echo "  test           - Run chart tests"
	@echo "  dry-run        - Dry run installation"
	@echo "  template       - Generate templates"
	@echo "  package        - Package the chart"
	@echo "  clean          - Clean generated files"

# Development installation
.PHONY: install-dev
install-dev:
	helm install $(RELEASE_NAME) . -f values-dev.yaml --namespace $(NAMESPACE) --create-namespace

# Production installation
.PHONY: install-prod
install-prod:
	helm install $(RELEASE_NAME) . -f values-prod.yaml --namespace $(NAMESPACE) --create-namespace

# Development upgrade
.PHONY: upgrade-dev
upgrade-dev:
	helm upgrade $(RELEASE_NAME) . -f values-dev.yaml --namespace $(NAMESPACE)

# Production upgrade
.PHONY: upgrade-prod
upgrade-prod:
	helm upgrade $(RELEASE_NAME) . -f values-prod.yaml --namespace $(NAMESPACE)

# Uninstall
.PHONY: uninstall
uninstall:
	helm uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)

# Lint the chart
.PHONY: lint
lint:
	helm lint .

# Test the chart
.PHONY: test
test:
	helm test $(RELEASE_NAME) --namespace $(NAMESPACE)

# Dry run
.PHONY: dry-run
dry-run:
	helm install $(RELEASE_NAME) . --dry-run --debug --namespace $(NAMESPACE)

# Generate templates
.PHONY: template
template:
	helm template $(RELEASE_NAME) . --namespace $(NAMESPACE)

# Package the chart
.PHONY: package
package:
	helm package .

# Clean generated files
.PHONY: clean
clean:
	rm -f *.tgz

# Validate Kubernetes manifests
.PHONY: validate
validate:
	helm template $(RELEASE_NAME) . | kubectl apply --dry-run=client -f -

# Show chart status
.PHONY: status
status:
	helm status $(RELEASE_NAME) --namespace $(NAMESPACE)

# Show chart values
.PHONY: values
values:
	helm get values $(RELEASE_NAME) --namespace $(NAMESPACE)

# Port forward to application
.PHONY: port-forward
port-forward:
	kubectl port-forward service/$(RELEASE_NAME)-$(CHART_NAME) 8080:80 --namespace $(NAMESPACE)

# Show application logs
.PHONY: logs
logs:
	kubectl logs -l app.kubernetes.io/name=$(CHART_NAME) --namespace $(NAMESPACE) -f
