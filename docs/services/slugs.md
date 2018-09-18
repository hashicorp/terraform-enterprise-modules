# Slugs

-----

## Deprecation warning:

The Terraform Enterprise AMI is no longer actively developed as of 201808-1 and will be fully decommissioned on November 30, 2018. As part of this deprecation, the modules and documentation in this repo are now unmaintained.

Please see our [Migration Guide](https://www.terraform.io/docs/enterprise/private/migrate.html) to migrate to the new Private Terraform Enterprise Installer.

-----

The `slug-*` services each perform a function on a bundle of Terraform or Packer config.

## `slug-extract`

The `slug-extract` service is responsible for extracting files from archives of data, typically Packer templates and Terraform Configuration.

It downloads a target archive (typically in a `.tar.gz` format) then unpacks and extracts a file. This file is then sent to the Atlas API to be stored.

This service is accessed as part of the file pipeline and may have a status of `extracting` in relation to a job or run.

### Impact of Failure

When failing, builds and runs may fail to proceed past the `extracting` phase. This can cause new builds and runs to not start or appear to be queued or pending.

### Dependencies

- `atlas-frontend`
- `binstore`
- `storagelocker`

## `slug-ingress`

The `slug-ingress` service is responsible for cloning files from version control services, typically git servers and services such as GitHub. These files are used in Terraform, Packer, or applications within Atlas.

The service clones and checks out specific refs for version control.

This service is accessed as part of the file pipeline and may have a status of `pending` in relation to a job or run.

### Impact of Failure

When failing, builds and runs may fail to proceed past the `pending` phase. This can cause new builds and runs to not start or appear to be queued or pending.

### Dependencies

- `atlas-frontend`
- `binstore`
- `storagelocker`

## `slug-merge`

The `slug-merge` service is responsible for combining archives of files, typically Packer templates and Terraform Configuration, or scripts sent with Packer and Terraform push commands or via version control services.

It downloads a set of target archives (typically in a `.tar.gz` format) unpacks each one and then combines and tars and compresses the result. This resulting archive is then sent to the Binstore service and a callback is issued to the Atlas Frontend.

This service is accessed as part of the file pipeline and may have a status of `merging` in relation to a job or run.

### Impact of Failure

When failing, builds and runs may fail to proceed past the `merging` phase. This can cause new builds and runs to not start or appear to be queued or pending.

### Dependencies

- `atlas-frontend`
- `binstore`
- `storagelocker`
