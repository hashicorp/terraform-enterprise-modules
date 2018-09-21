-----

## Deprecation warning:

The Terraform Enterprise AMI is no longer actively developed as of 201808-1 and will be fully decommissioned on November 30, 2018. As part of this deprecation, the modules and documentation in this repo are now unmaintained.

Please see our [Migration Guide](https://www.terraform.io/docs/enterprise/private/migrate.html) to migrate to the new Private Terraform Enterprise Installer.

-----

_Below is a sample Terraform configuration designed to always have changes. The changes do not make any changes to active infrastructure. Rather, they output a random uuid to allow for quick iteration when testing Terraform Enterprise's plan and apply functionality._

Copy the below HCL into `main.tf` in a test repository, as this configuration will be used to verify the Private Terraform Enterprise installation:

```HCL
resource "random_id" "random" {
  keepers {
    uuid = "${uuid()}"
  }

  byte_length = 8
}

output "random" {
  value = "${random_id.random.hex}"
}
```
