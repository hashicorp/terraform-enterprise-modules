# Terraform Enterprise AMI IDs

Below are the AMI IDs for each Terraform Enterprise release.

Once your AWS Account is granted launch permissions, these AMI IDs should be
used as inputs to the Terraform configuration in this repository for launching
Terraform Enterprise.

See also the [CHANGELOG](../CHANGELOG.md).

If you wish to use an AMI with encrypted EBS snapshots, you'll need to make
a private copy. We have documented that procedure in [Encrypted AMI](encrypt-ami.md).

### NOTE

The `v201707-1` and `v201707-2` releases have issues with being used to upgrade
from previous releases. Best to skip them entirely.

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
| **[v201706-2](../CHANGELOG.md#v201706-2)** | us-west-2     | `ami-c0353ab9` |
|                                            | us-east-1     | `ami-cef6a6d8` |
|                                            | us-gov-west-1 | `ami-176ceb76` |
|                                            | eu-west-1     | `ami-c4e0f3a2` |
| **[v201706-3](../CHANGELOG.md#v201706-3)** | us-west-2     | `ami-4a010f33` |
|                                            | us-east-1     | `ami-27623d31` |
|                                            | us-gov-west-1 | `ami-13028572` |
|                                            | eu-west-1     | `ami-0869746e` |
| **[v201706-4](../CHANGELOG.md#v201706-4)** | us-west-2     | `ami-0c5c4a75` |
|                                            | us-east-1     | `ami-dcbb8aca` |
|                                            | us-gov-west-1 | `ami-d0ab2db1` |
|                                            | eu-west-1     | `ami-b72ecbce` |
| ~~**[v201707-1](../CHANGELOG.md#v201707-1)**~~ | us-west-2     | `ami-e8d7c991` |
|                                            | us-east-1     | `ami-91dc83ea` |
|                                            | us-gov-west-1 | `ami-37870656` |
|                                            | eu-west-1     | `ami-90d833e9` |
| ~~**[v201707-2](../CHANGELOG.md#v201707-2)**~~ | us-west-2     | `ami-830218fa` |
|                                            | us-east-1     | `ami-dbda85a0` |
|                                            | us-gov-west-1 | `ami-e764e586` |
|                                            | eu-west-1     | `ami-53d3382a` |
| **[v201708-1](../CHANGELOG.md#v201708-1)** | us-west-2     | `ami-0585657d` |
|                                            | us-east-1     | `ami-42311839` |
|                                            | us-gov-west-1 | `ami-04e16165` |
|                                            | eu-west-1     | `ami-d7f607ae` |
| **[v201708-2](../CHANGELOG.md#v201708-2)** | us-west-2     | `ami-3cb95444` |
|                                            | us-east-1     | `ami-6d4f7c16` |
|                                            | us-gov-west-1 | `ami-ff9e1e9e` |
|                                            | eu-west-1     | `ami-8133c1f8` |
| **[v201709-1](../CHANGELOG.md#v201709-1)** | us-west-2     | `ami-4b15e533` |
|                                            | us-east-1     | `ami-c7ff1bbd` |
|                                            | us-gov-west-1 | `ami-6950d308` |
|                                            | eu-west-1     | `ami-039f5c7a` |
| **[v201709-2](../CHANGELOG.md#v201709-2)** | us-west-2     | `ami-7abe4602` |
|                                            | us-east-1     | `ami-69738113` |
|                                            | us-gov-west-1 | `ami-5efd7f3f` |
|                                            | eu-west-1     | `ami-425a913b` |
| **[v201709-3](../CHANGELOG.md#v201709-3)** | us-west-2     | `ami-d63bc3ae` |
|                                            | us-east-1     | `ami-dece37a4` |
|                                            | us-gov-west-1 | `ami-ad9d1fcc` |
|                                            | eu-west-1     | `ami-ba2ffac3` |
| **[v201711-1](../CHANGELOG.md#v201711-1)** | us-west-2     | `ami-36b8734e` |
|                                            | us-east-1     | `ami-4cd37b36` |
|                                            | us-gov-west-1 | `ami-0e018c6f` |
|                                            | eu-west-1     | `ami-1164c568` |
| **[v201712-1](../CHANGELOG.md#v201712-1)** | us-west-1     | `ami-540a0f34` |
|                                            | us-west-2     | `ami-a53e9bdd` |
|                                            | us-gov-west-1 | `ami-6dbd320c` |
|                                            | us-east-1     | `ami-8e8fedf4` |
|                                            | eu-west-1     | `ami-a27dc5db` |
|                                            | eu-west-2     | `ami-fdeef099` |
| **[v201712-2](../CHANGELOG.md#v201712-2)** | us-west-1     | `ami-9f0f08ff` |
|                                            | us-west-2     | `ami-0c319274` |
|                                            | us-gov-west-1 | `ami-e83db289` |
|                                            | us-east-1     | `ami-fbf48881` |
|                                            | eu-west-1     | `ami-20af2f59` |
|                                            | eu-west-2     | `ami-57243d33` |
| **[v201801-1](../CHANGELOG.md#v201801-1)** | us-west-1     | `ami-94e7e4f4` |
|                                            | us-west-2     | `ami-bf68dec7` |
|                                            | us-gov-west-1 | `ami-93da53f2` |
|                                            | us-east-1     | `ami-5cf3d726` |
|                                            | eu-west-1     | `ami-0225b87b` |
|                                            | eu-west-2     | `ami-34687350` |
