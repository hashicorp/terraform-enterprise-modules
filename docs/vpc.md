# VPC

-----

## Deprecation warning:

The Terraform Enterprise AMI is no longer actively developed as of 201808-1 and will be fully decommissioned on November 30, 2018. As part of this deprecation, the modules and documentation in this repo are now unmaintained.

Please see our [Migration Guide](https://www.terraform.io/docs/enterprise/private/migrate.html) to migrate to the new Private Terraform Enterprise Installer.

-----

Terraform Enterprise is design to be installed into a preexisting VPC. This
gives you flexibility about how you run and utilize the product.

The VPC needs to have the following features:

* At least 2 subnets in different availability zones to perform proper RDS
  redundency.
* If you'll be accessing the product over the internet, you'll need at least
  one public subnet and configured for the ELB to use.


### Demo VPC Terraform

If you wish to build a new VPC from scratch, we have provided a sample
terraform module you can use to do so. When you run `terraform plan` or
`terraform apply` it will ask you what to call the VPC and what AWS region to
put it in. Once it's finished applying, you can use the subnet ids it outputs
to configure the product.

[Demo VPC Terraform](./demo-base-vpc)
