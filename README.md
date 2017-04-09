# Terraform Enterprise Modules

These are Terraform modules for setting up Terraform Enterprise inside a customer's infrastructure (aka Private Terraform Enterprise).

[![terraform-enterprise-banner](docs/assets/terraform-enterprise-banner.png)](https://www.hashicorp.com/products/terraform/)

## Install Flavors

![aws-infra-architecture](docs/assets/aws-infra-architecture.png)

Each of the `aws-` prefixed directories contains a full Terraform Enterprise installation for a certain situation.

Please see the documentation for the relevant install flavor:

* [`aws-standard`](aws-standard/) - Manages compute, data layer and (optionally) Route 53 DNS.
* [`aws-expert`](aws-expert/) - Manages compute layer only, customer manages DNS and data layer separately.

Each install flavor can either be used as a Terraform root directory or as a module invoked from other Terraform config.

## Documentation

Further documentation can be found in the [`docs`](docs/) subdir.
