# Using an Encrypted AMI

-----

## Deprecation warning:

The Terraform Enterprise AMI is no longer actively developed as of 201808-1 and will be fully decommissioned on November 30, 2018. As part of this deprecation, the modules and documentation in this repo are now unmaintained.

Please see our [Migration Guide](https://www.terraform.io/docs/enterprise/private/migrate.html) to migrate to the new Private Terraform Enterprise Installer.

-----

If you wish to backup your instance using EBS snapshots with encryption,
you'll need to copy the official AMI to your account and configure it with
encryption.

In the AWS Console, go to AMIs under the EC2 subsystem. Change the selector to
"Private Images", and select the AMI you wish to make a copy of:

![Select the AMI](assets/select-ami.png)

Then in the copy configuration, select Encryption:

![Select Encryption](assets/encrypt-ebs.png)

And click *Copy AMI*. Once the copy operation is finished, you can use the
newly created AMI's ID in your `terraform.tfvars` file to install Terraform
Enterprise.
