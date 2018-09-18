# Archivist

-----

## Deprecation warning:

The Terraform Enterprise AMI is no longer actively developed as of 201808-1 and will be fully decommissioned on November 30, 2018. As part of this deprecation, the modules and documentation in this repo are now unmaintained.

Please see our [Migration Guide](https://www.terraform.io/docs/enterprise/private/migrate.html) to migrate to the new Private Terraform Enterprise Installer.

-----

Archivist is the service responsible for uploads, downloads and log streaming.
It is a single service that will replace the following three services soon.

## `logstream`

The Logstream service is responsible for streaming logs for Terraform and Packer runs from the service executing them to the user via JavaScript running in a web browser.

The JavaScript directly polls the Logstream Service and updates the view in the browser with new data available from the run or build.

This is one only a few services that is directly accessible for Terraform Enterprise users. Issues with logs not displaying are typically related to the TFE file pipeline or Packer or Terraform execution, as Logstream is just responsible for copying log data from storage to the browser.

Logstream stores logs in both hot and cold storage, so initial loads can be slightly slower than cached loads.

### Impact of Failure

When failing, builds and runs may not show logs to the user, making it hard determine progress or if a build is failing, where the failure is.

### Dependencies

- [Atlas](atlas.md)
- Storagelocker
- Redis

## `binstore` & `storagelocker`

Together, these services provide object storage for other services in the system. This includes configuration files, Terraform Plans, and logs from  Packer Builds and Terraform Runs.

## Impact of Failure

Problems with objects making their way through the build pipelines can point to problems with `binstore` or `storagelocker`.

## Dependencies

- S3 for backend storage
- Redis for coordination
