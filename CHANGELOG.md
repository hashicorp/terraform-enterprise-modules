# Changelog

Terraform Enterprise release versions have the format:

```
vYYYYMM-N
```

Where:

 * `YYYY` and `MM` are the year and month of the release.
 * `N` is increased with each release in a given month, starting with `1`

## v201704-2

FEATURES:

 * ami: Add `hashicorp-support` script to create an encrypted bundle of
   diagnostic information for passing to HashiCorp Support
 * terraform: Allow `kms_key_id` to be optionally specified as input

IMPROVEMENTS:

 * ami: Switch main SSH username to `tfe-admin` from default `ubuntu`
 * terraform: remove unused `az` variable

BUG FIXES:

 * ami: Allow AMI to be used in downstream Packer builds without triggering
   bootstrap behavior

## v201704-1

FEATURES:

IMPROVEMENTS:

 * config: Disable Consul remote exec

BUG FIXES:

 * config: Install git inside build worker Docker container to facilitate terraform module fetching
 * config: Don't redirect traffic incoming from local build workers

## v201703-2

FEATURES:

IMPROVEMENTS:

BUG FIXES:

 * config: Prevent race condition by waiting until Consul is running before continuing boot 
 * config: Ensure that Vault is unsealed when instance reboots

## v201703-1

 * Initial release!
