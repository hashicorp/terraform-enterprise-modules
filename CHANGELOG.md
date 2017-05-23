# Changelog

Terraform Enterprise release versions have the format:

```
vYYYYMM-N
```

Where:

* `YYYY` and `MM` are the year and month of the release.
* `N` is increased with each release in a given month, starting with `1`

## vNext (Unreleased)

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
