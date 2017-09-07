# Changelog

Terraform Enterprise release versions have the format:

```
vYYYYMM-N
```

Where:

* `YYYY` and `MM` are the year and month of the release.
* `N` is increased with each release in a given month, starting with `1`

## Upcoming

MACHINE IMAGE FEATURES:

  * Add ability to prompt for setup data and store it inside Vault rather than
    store it in S3+KMS (activated via new `local_setup` Terraform option).

TERRAFORM CONFIG FEATURES:

  * Add `local_setup` variable to tell TFE to prompt for setup data on first
    boot and store it within Vault rather than rely on S3+KMS for setup data.

## v201708-2 (Aug 16, 2017)

MACHINE IMAGE BUG FIXES:

  * Correct out of memory condition with various internal services that prevent
    proper operation.

## v201708-1 (Aug 8, 2017)

APPLICATION LEVEL BUG FIXES:

  * Fixes a bug where TF slugs would only get encrypted during terraform push.
  * Fixes state parser triggering for states stored in external storage (Archivist).
  * Fixes a bug where encryption contexts could be overwritten.
  * Send commit status updates to the GitHub VCS provider when plan is "running" (cosmetic)

MACHINE IMAGE BUG FIXES:

  * Manage upgrading from v201706-4 and earlier properly.

## v201707-2 (July 26, 2017)

APPLICATION LEVEL BUG FIXES:

  * Send commit status updates to VCS providers while waiting for MFA input

## v201707-1 (July 18, 2017)

APPLICATION LEVEL FEATURES:

  * Add support for releases up to Terraform 0.9.9.

APPLICATION LEVEL BUG FIXES:

  * Displays an error message if the incorrect MFA code is entered to confirm a Run.
  * Address issue with large recipient groups in new admin notification emails.
  * Fixes a 500 error on the Events page for some older accounts.
  * Fix provider names in new environment form.
  * Update wording in the Event Log for version control linking and unlinking.
  * Fetch MFA credential from private registries when enabled.
  * Fix ability to cancel Plans, Applies, and Runs

MACHINE IMAGE FEATURES:

  * Add ability to use local redis.
  * This adds a new dependency on EBS to store the redis data.

TERRAFORM CONFIG FEATURES:

  * Add `local_redis` variable to configure cluster to use redis locally, eliminating
    a dependency on ElasticCache.
  * Add `ebs_size` variable to configure size of EBS volumes to create to store local
    redis data.
  * Add `ebs_redundancy` variable to number of EBS volumes to mirror together for
    redundancy in storing redis data.
  * Add `iam_role` as an output to allow for additional changes to be applied to
    the IAM role used by the cluster instance.


## v201706-4 (June 26, 2017)

APPLICATION LEVEL FEATURES:

  * Add support for releases up to Terraform 0.9.8.

APPLICATION LEVEL BUG FIXES:

  * VCS: Send commit status updates after every `terraform plan` that has a
    commit.
  * Fix admin page that displays Terraform Runs.
  * Remove application identifying HTTP headers.

MACHINE IMAGE BUG FIXES:

  * Fix `rails-console` to be more usable and provide a command prompt.
  * Fix DNS servers exposed to builds to use DNS servers that are configured
    for the instance.
  * Redact sensitive information from error output generated while talking to
    VCS providers.
  * Refresh tokens for Bitbucket and GitLab properly.
  * Update build status on Bitbucket Cloud PRs.

EXTRAS CHANGES:

  * Parametirez s3 endpoint region used for setup of S3 <=> VPC peering.


## v201706-3 (June 7, 2017)

MACHINE IMAGE BUG FIXES:

  * Exclude all cluster local traffic from using the outbound proxy.

## v201706-2 (June 5, 2017)

APPLICATION LEVEL BUG FIXES:

  * Clear all caches on boot to prevent old records from being used.

MACHINE IMAGE FEATURES:

  * Added `clear-cache` to clear all caches used by the cluster.
  * Added `rails-console` to provide swift access to the Ruby on Rails
    console, used for lowlevel application debugging and inspection.

## v201706-1 (June 1, 2017)

APPLICATION LEVEL FEATURES:

  * Improve page load times.
  * Add support for releases up to Terraform 0.9.6.
  * Make Terraform the default page after logging in.

APPLICATION LEVEL BUG FIXES:

  * Bitbucket Cloud stability improvements.
  * GitLab stability improvements.
  * Address a regression for Terraform Runs using Terraform 0.9.x that
    caused Plans run on non-default branches (e.g. from Pull Requests)
    to push state and possibly conflict with default branch Terraform Runs.
  * Ignore any state included by a `terraform push` and always use state
    within Terraform Enterprise.
  * Prevent `terraform init` from accidentially asking for any input.
  * Allow sensitive variable to be updated.
  * Fix "Settings" link in some cases.

MACHINE IMAGE FEATURES:

  * Automatically scale the number of total concurrent builds up based on
    the amount of memory available in the instance.
  * Add ability to configure instance to send all outbound HTTP and HTTPS
    traffic through a user defined proxy server.

TERRAFORM CONFIG FEATURES:

  * Add `proxy_url` variable to configure outbound HTTP/HTTPS proxy.

DOCUMENTATION CHANGES:

  * Remove deprecated references to Consul environments.
  * Include [Encrypted AMI](docs/encrypt-ami.md) for information on using
    encrypted AMIs/EBS.
  * Add [`network-access`](docs/network-access.md) with information about
    the network access required by TFE.
  * Add [`managing-tool-versions`](docs/managing-tool-versions.md) to document
    usage of the `/admin/tools` control panel.

## v201705-2 (May 23, 2017)

APPLICATION LEVEL CHANGES:

  * Prevent sensitive variables from being sent in the clear over the API.
  * Improve setup UI.
  * Add support for releases up to Terraform 0.9.5.
  * Fix bug that prevented packer runs from having their logs automatically
    display.

MACHINE IMAGE CHANGES:

  * Fix archivist being misreported as failing checks.
  * Add ability to add SSL certificates to be trusted into /etc/ssl/certs.
  * Add awscli to build context for use with local\_exec.
  * Infer the s3 endpoint from the region to support different AWS partitions.
  * Add ability to run custom shell code on the first boot.

TERRAFORM CONFIG CHANGES:

  * Add `startup_script` to allow custom shell code to be injected and run on
    first boot.
  * Allow for customer managed security groups.


DOCUMENTATION CHANGES:

  * Include [documentation](docs/support.md) on sending support information via the
    `hashicorp-support` tool.

## v201705-1 (May 12, 2017)

APPLICATION LEVEL CHANGES:

 * Improve UI performance by reducing how often and when pages poll for new
   results.
 * Add support for releases up to Terraform 0.9.4.
 * Add support for releases up to Packer 0.12.3.
 * Fix the From address in email sent by the system.
 * Allow amazon-ebssurrogate builder in Packer.
 * Handle sensitive variables from `packer push`.
 * Improve speed of retrieving and uploading artifacts over HTTP.
 * Added integrations with GitLab and BitBucket Cloud.
 * Removed Consul and Applications functionality.

MACHINE IMAGE CHANGES:

 * Fix an issue preventing the `hashicorp-support` command from successfully
   generating a diagnostic bundle.
 * Fix ability to handle more complex database paswords.
 * More explicit region utilization in S3 access to support S3 in Govcloud.

TERRAFORM CONFIG CHANGES:

 * Make `region` a required input variable to prevent any confusion from the
   default value being set to an unexpected value. Customers who were not
   already setting this can populate it with the former default: `"us-west-2"`
 * Add ability to specify the aws partition to support govcloud.
 * Reorganize supportive modules into a separate `aws-extra` directory
 * Remove a stale output being referenced in `vpc-base`
 * Work around a Terraform bug that prevented the outputs of `vpc-base` from
   being used as inputs for data subnets.
 * Explicitly specify the IAM policy of the KMS key when creating it.
 * Add an Alias to the created KMS key so it is more easily identifiable AWS
   console.
 * Add ability to start the ELB in internal mode.
 * Specify KMS key policy to allow for utilization of the key explicitly by
   the TFE instance role.
 * Add KMS alias for key that is utilized for better inventory tracking.


## v201704-3

APPLICATION LEVEL CHANGES:

(none)

MACHINE IMAGE CHANGES:

* Properly handle database passwords with non-alphanumeric characters
* Remove nginx's `client_max_body_size` limit so users can upload files larger than 1MB

TERRAFORM CONFIG CHANGES:

* Fix var reference issues when specifying `kms_key_id` as an input
* Add explicit IAM policy to KMS key when Terraform manages it
* Add explicit KMS Key Alias for more easily referencing the KMS key in the AWS Web Console

## v201704-2

APPLICATION LEVEL CHANGES:

(none)

MACHINE IMAGE CHANGES:

* Add `hashicorp-support` script to create an encrypted bundle of diagnostic information for passing to HashiCorp Support
* Switch main SSH username to `tfe-admin` from default `ubuntu`
* Allow AMI to be used in downstream Packer builds without triggering bootstrap behavior

TERRAFORM CONFIG CHANGES:

* Allow `kms_key_id` to be optionally specified as input
* Remove unused `az` variable

## v201704-1

APPLICATION LEVEL CHANGES:

(none)

MACHINE IMAGE CHANGES:

* Disable Consul remote exec
* Install git inside build worker Docker container to facilitate terraform module fetching
* Don't redirect traffic incoming from local build workers

TERRAFORM CONFIG CHANGES:

* Prevent extraneous diffs after RDS database creation

## v201703-2

APPLICATION LEVEL CHANGES:

(none)

MACHINE IMAGE CHANGES:

* Prevent race condition by waiting until Consul is running before continuing boot 
* Ensure that Vault is unsealed when instance reboots

## v201703-1

* Initial release!
