default: help

ATLAS_ENVIRONMENT = "hashicorp-engservices/demo-vpc"

.PHONY: config
config: ## Configure remote state for Atlas - set TF_OPTS for additional flags
	terraform remote config \
		-backend="atlas" \
		-backend-config="name=$(ATLAS_ENVIRONMENT)" \
		$(TF_OPTS)

.PHONY: plan
plan: ## Run a Terraform plan operation - set TF_OPTS for additional flags
	terraform get $(TF_OPTS) terraform/
	terraform plan $(TF_OPTS) terraform/

.PHONY: apply
apply: ## Run a Terraform apply operation - set TF_OPTS for additional flags
	terraform apply $(TF_OPTS) terraform/

.PHONY: refresh
refresh: ## Run a Terraform refresh operation - set TF_OPTS for additional flags
	terraform refresh $(TF_OPTS) terraform/

.PHONY: destroy
destroy: ## Run a Terraform destroy operation - set TF_OPTS for additional flags
	@terraform destroy $(TF_OPTS) terraform/

.PHONY: output
output: ## Show Terraform outputs - set TF_OPTS for individual fields
	@terraform output $(TF_OPTS)

.PHONY: graph
graph: ## Draw a graph of the infrastructure dependencies
	@terraform graph terraform/ | dot -Tpdf > graph.pdf

.PHONY: help
help:
	@echo "Valid targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

