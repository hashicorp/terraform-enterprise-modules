# Changelog

Terraform Enterprise release versions have the format:

```
vYYYYMM-N
```

Where:

 * `YYYY` and `MM` are the year and month of the release.
 * `N` is increased with each release in a given month, starting with `1`

## v201703-1

 * Initial release!

## v201703-2

FEATURES:

IMPROVEMENTS:

BUG FIXES:

 * config: Prevent race condition by waiting until Consul is running before continuing boot 
 * config: Ensure that Vault is unsealed when instance reboots

## v201704-1

FEATURES:

IMPROVEMENTS:

 * config: Disable Consul remote exec

BUG FIXES:

 * config: Install git inside build worker Docker container to facilitate terraform module fetching
 * config: Don't redirect traffic incoming from local build workers
