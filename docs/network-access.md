# Network Access

-----

## Deprecation warning:

The Terraform Enterprise AMI is no longer actively developed as of 201808-1 and will be fully decommissioned on November 30, 2018. As part of this deprecation, the modules and documentation in this repo are now unmaintained.

Please see our [Migration Guide](https://www.terraform.io/docs/enterprise/private/migrate.html) to migrate to the new Private Terraform Enterprise Installer.

-----

This document details the ingress and egress network access required by Terraform Enterprise to function properly.

## Ingress Traffic

Terraform Enterprise (TFE) requires certain ports to be accessible for it to function. The Terraform configuration that ships with TFE will by default create Security Groups (SGs) that make the appropriate ports available, but you can also specify custom SGs to be used instead.

Here are the two SGs in the system relevant for user access and the ports they require to be open:

* **Load Balancer SG**: Applied to the Elastic Load Balancer (ELB), controls incoming HTTP traffic from users
  * **Port 443** must be accessible to users for basic functionality, must also be accessible from the VPC itself, as certain internal services reach over the ELB to access cross-service APIs
  * **Port 80** is recommended to leave open for convenience - the system is set up to force SSL by redirecting users who visit TFE over HTTP to the HTTPS equivalent URL. If this port is not available, users who mistakenly visit the site over HTTP will see hanging requests in their browser
* **Instance SG**: Applied to the EC2 Instance running the application
  * **Port 8080** must be accessible to the ELB to serve traffic
  * **Port 22** must be accessible to operators to perform diagnostics and troubleshooting over SSH

There are also two internal SGs that are not currently user configurable:

* **Database SG**: Applied to the RDS instance - allows the application to talk to PostgreSQL
* **Redis SG**: Applied to the ElastiCache instance - allows the application to talk to Redis

## Egress Traffic

Terraform Enterprise (TFE) makes several categories of outbound requests, detailed in the sections below.

### Primary Data Stores

**S3** is used for object storage, so access to the AWS S3 API and endpoints is required for basic functionality

**RDS and ElastiCache** instances are provisioned for application data storage. These instances are within the same VPC as the application, and so communication with them does not constitute outbound traffic

### Version Control System Integrations

TFE can be configured with any of a number of **[Version Control Systems (VCSs)](https://www.terraform.io/docs/enterprise/vcs/index.html)**, some supporting both SaaS and private-network installations.

In order to perform ingress of Terraform and Packer configuration from a configured VCS, TFE will need to be able to communciate with that provider's API, and webhooks from that provider will need to be able to reach TFE.

For example, an integration with GitHub will require TFE to have access to https://github.com and for GitHub's webhooks to be able to route back to TFE. Similarly, an integration with GitHub Enterprise will require TFE to have access to the local GitHub instance.

### Packer and Terraform Execution

As a part of their primary mode of operation, Packer and Terraform both make API calls out to infrastructure provider APIs. Since TFE runs Terraform and Packer on behalf of users, TFE will therefore need access to any Provider APIs that your colleagues want to manage with TFE.

### Packer and Terraform Release Downloading

By default, TFE downloads the versions of Packer and Terraform that it executes from https://releases.hashicorp.com/ - though this behavior can be customized by specifying different download locations. See [`managing-tool-versions`](managing-tool-versions.md).

### Packer and Terraform Latest Version Notifications

When displaying Terraform Runs and Packer Builds, TFE has JavaScript that reaches out to https://checkpoint.hashicorp.com to determine the latest released version of Packer and Terraform and notify users if there is a newer version available than the one they are running. This functionality non-essential - new version notifications will not be displayed in the Web UI if checkpoint.hashicorp.com cannot be reached from a user's browser.

### Communication Functions

* TFE uses the configured SMTP endpoint for sending emails
* Twilio can optionally be set up for for SMS-based 2FA (virtual TOTP support is available separately which does not make external API calls)
