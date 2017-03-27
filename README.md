# Terraform Enterprise Modules

These are Terraform modules for setting up infrastructure that can host
Terraform Enterprise inside a customer's infrastructure (aka Private Terraform
Enterprise).

![aws-infra-architecture](docs/assets/aws-infra-architecture.png)

## Install Flavors

Each of the `aws-` prefixed directories contains a full Terraform Enterprise
installation for a certain situation.

Please see the documentation for the relevent install flavor:

* [`aws-standard`](aws-standard/) - Terraform manages compute, data layer and Route 53 DNS.
* [`aws-standard-nodns`](aws-standard-nodns/) - Terraform manages compute and data layer, customer manages DNS separately.
* [`aws-expert`](aws-expert/) - Terraform manages compute layer only, customer manages DNS and data layer separately.

Each install flavor can be used as a Terraform root directory or as a module.
