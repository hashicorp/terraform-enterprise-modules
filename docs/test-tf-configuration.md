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
