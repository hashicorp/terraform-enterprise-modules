# TFE Release Documentation

-----

## Deprecation warning:

The Terraform Enterprise AMI is no longer actively developed as of 201808-1 and will be fully decommissioned on November 30, 2018. As part of this deprecation, the modules and documentation in this repo are now unmaintained.

Please see our [Migration Guide](https://www.terraform.io/docs/enterprise/private/migrate.html) to migrate to the new Private Terraform Enterprise Installer.

-----

This directory contains supporting documentation for Terraform Enterprise (TFE)
releases.

* [`about-the-ami`](about-the-ami.md) - Details about the TFE Base AMI
* [`ami-ids`](ami-ids.md) - A list of the TFE release AMI IDs for each region
* [`aws-extra`](../aws-extra/README.md) - Some additional configuration information meant to support deployment of Private TFE in AWS.
* [`aws-standard`](../aws-standard/README.md) - Instructions for deploying Private TFE in AWS
* [`legacy`](legacy.md) - Information about upgrading from a Legacy TFE architecture
* [`logs`](logs.md) - Information about working with TFE logs
* [`managing-tool-versions`](managing-tool-versions.md) - Details about managing the versions and locations of Packer and Terraform used by TFE
* [`migrating-from-tfe-saas`](migrating-from-tfe-saas.md) - Instructions on how to move config from TFE SaaS to a Private TFE installation
* [`network-access`](network-access.md) - Information about the network access required by TFE
* [`storing-tfe-state`](storing-tfe-state.md) - Recommendations on how to manage the Terraform State of the TFE install process
* [`support`](support.md) - Getting help when things are not working as expected
* [`tfe-architecture`](tfe-architecture.md) - Information on TFE's architecture
* [`advanced-terraform`](advanced-terraform.md) - Information on more advanced ways to use the terraform modules
* [`vault-rekey`](vault-rekey.md) - Information on rekeying the Vault instance used by TFE
