# Terraform Enterprise AMI IDs

Below are the AMI IDs for each Terraform Enterprise release.

Once your AWS Account is granted launch permissions, these AMI IDs should be
used as inputs to the Terraform configuration in this repository for launching
Terraform Enterprise.

See also the [CHANGELOG](../CHANGELOG.md).

If you wish to use an AMI with encrypted EBS snapshots, you'll need to make
a private copy. We have documented that procedure in [Encrypted AMI](encrypt-ami.md).

| TFE Release                                | Region        | AMI ID         |
| ------------------------------------------ | ------------- | -------------- |
| **[v201703-1](../CHANGELOG.md#v201703-1)** | us-west-2     | `ami-4844d128` |
|                                            | us-east-1     | `ami-0273cd14` |
| **[v201703-2](../CHANGELOG.md#v201703-2)** | us-west-2     | `ami-a664f0c6` |
|                                            | us-east-1     | `ami-a5dc66b3` |
| **[v201704-1](../CHANGELOG.md#v201704-1)** | us-west-2     | `ami-f81e8898` |
|                                            | us-east-1     | `ami-20ab2836` |
| **[v201704-2](../CHANGELOG.md#v201704-2)** | us-west-2     | `ami-3be5785b` |
|                                            | us-east-1     | `ami-a0b222b6` |
| **[v201704-3](../CHANGELOG.md#v201704-3)** | us-west-2     | `ami-8471ede4` |
|                                            | us-east-1     | `ami-33841b25` |
| **[v201705-1](../CHANGELOG.md#v201705-1)** | us-west-2     | `ami-966105f6` |
|                                            | us-east-1     | `ami-38d2a22e` |
|                                            | us-gov-west-1 | `ami-c120a4a0` |
| **[v201705-2](../CHANGELOG.md#v201705-2)** | us-west-2     | `ami-4d70102d` |
|                                            | us-east-1     | `ami-518ecf47` |
|                                            | us-gov-west-1 | `ami-48fb7c29` |
| **[v201706-1](../CHANGELOG.md#v201706-1)** | us-west-2     | `ami-f00d6190` |
|                                            | us-east-1     | `ami-46530450` |
|                                            | us-gov-west-1 | `ami-5151d630` |
|                                            | eu-west-1     | `ami-14c3d372` |
