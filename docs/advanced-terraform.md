# Advanced Terraform

-----

## Deprecation warning:

The Terraform Enterprise AMI is no longer actively developed as of 201808-1 and will be fully decommissioned on November 30, 2018. As part of this deprecation, the modules and documentation in this repo are now unmaintained.

Please see our [Migration Guide](https://www.terraform.io/docs/enterprise/private/migrate.html) to migrate to the new Private Terraform Enterprise Installer.

-----

The `aws-standard` terraform module can be as a true terraform module
to enable some additional features for configure the cluster.


### Additional IAM Role policies

The module outputs the role name used by the instance, allowing you
to attach additional policies to configure access:

```hcl
provider "aws" {
  region = "us-west-2"
}

module "standard" {
  source = "../../terraform/aws-standard"
  # Variables that would be in terraform.tfvars go here
}

data "aws_iam_policy_document" "extra-s3-perms" {
  statement {
    sid    = "AllowS3Access"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::my-private-artifacts/*",
      "arn:aws:s3:::my-private-artifacts",
    ]

    actions = [
      "s3:*",
    ]
  }
}

resource "aws_iam_role_policy" "extra-s3-perms" {
  role   = "${module.standard.iam_role}"
  policy = "${data.aws_iam_policy_document.extra-s3-perms.json}"
}

```
