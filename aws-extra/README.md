# Tertiary AWS Terraform Configs

Each subdirectory contains a set of Terraform Configuration meant to support the primary Terraform Enterprise installation configs present in [`aws-standard`](../aws-standard).

 * [`base-vpc`](base-vpc/) - Configuration for creating a basic VPC and subnets that meet [the documented requirements for TFE installation](../aws-standard/README.md#preflight).
 * [`minimum-viable-iam`](minimum-viable-iam/) - Configuration for creating an AWS user with a minimum access policy required to perform a Terraform Enterprise installation.
