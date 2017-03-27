# Private Terraform Enterprise

## Delivery

The goal of this installation procedure is to setup a Terraform Enterprise cluster that is available on a DNS name that is accessed via https. This standard configuration package uses Route53 to configure the DNS automatically, all that needs to be provided is a hostname and a zone id. For example, if you want the cluster available at `tfe.mycompany.io`, then you'd provide `tfe` as the hostname and a zone id for the Route53 configuration of `mycompany.io`.

If you don't wish to use Route53 for your DNS, please use the `aws-standard-nodns` package, which will configure everything and output values you need to setup in your DNS by hand.

## Preflight

Before setup begins, a few resources need to be provisioned. We consider
these out of scope for the cluster provisioning because they depend
on the users environment.

* AWS IAM credentials capable of creating new IAM roles configuring various services. We suggest you use an admin role for this. The credentials are only used for setup, during runtime only an assumed role is used.
* AWS VPC containing at least 2 subnets. These will be used to launch the cluster into. Subnets do not need to be public, but they do need an internet gateway at present.
* A TLS certification registered with AWS Certificate Manager. This can be one created by CM for a hostname or the certificate can be imported into it.
  * To create a new one: https://console.aws.amazon.com/acm/home#/wizard/
  * To import an existing cert: https://console.aws.amazon.com/acm/home#/importwizard/
  * *NOTE:* Certificates are per region, so be sure to create them in the same region as you'll be deploying Terraform Enterprise
  * *NOTE:* The certification must allow the fully qualified hostname that Terraform Enterprise will be using. This means you need to decide on the value of hostname when creating the certificates and use the same value in the configuration.


### Variables

* hostname: The name that cluster will be registered as. This combined with the zone information will form the DNS name that the cluster is accessed at. See the note in [Delivery](#Delivery) about what this should be. Example: `emp-test`
* zone\_id: The id of a Route53 zone that a record for the cluster will be installed into. Example: `ZVEF52R7NLTW6`
* cert\_id: An AWS certificate ARN. This is the certification that will be used by the ELB for the cluster. Example: `arn:aws:acm:us-west-2:241656615859:certificate/f32fa674-de62-4681-8035-21a4c81474c6`
* instance\_subnet\_id: Subnet id of the subnet that the cluster's instance will be placed into. If this is a public subnet, the instance will be assigned a public IP. This is not required as the primary cluster interface is an ELB registered with the hostname. Example: `subnet-0de26b6a`
* elb\_subnet\_id: Subnet id of the subnet that the cluster's instance will be placed into. If this is a public subnet, the instance will be assigned a public IP. This is not required as the primary cluster interface is an ELB registered with the hostname. Example: `subnet-0de26b6a`
* data\_subnet\_ids: Subnet ids that will be used to create the data services (RDS and redis) used by the cluster. There must be 2 subnet ids given for proper redundency. Example: `["subnet-0ce26b6b", "subnet-d0f35099"]`
* db\_password: Password that will be used to access RDS. Example: `databaseshavesecrets`
* bucket\_name: Name of the S3 bucket to store artifacts used by the cluster into. This bucket is automatically created. We suggest you name it `tfe-${hostname}-data`, as convention.
* key\_name: Name of AWS ssh key pair that will be used. The pair needs to already exist, it will not be created.

### Optional Variables

These variables can be populated, but they have defaults that can also be used.

* region: The AWS region to deploy into. Default: `us-west-2`
* az: The AWS availability zone to use within the region. Default: `us-west-2a`
* manage\_bucket: Indicate if this terraform state should create and own the bucket. Set this to false if you are reusing an existing bucket.
* db\_username: Username that will be used to access RDS. Default: `atlas`
* db\_size\_gb: Disk size of the RDS instance to create. Default: `80`
* db\_instance\_class: Instance type of the RDS instance to create. Default: `db.m4.large`
* db\_multi\_az: Configure if the RDS cluster should multiple AZs to improve snapshot performance. Default: `true`
* db\_snapshot\_identifier: Previously made snapshot to restore when RDS is created. This is for migration of data between clusters. Default is to create the database fresh.

### Populating Variables

The values for these variables should be placed into terraform.tfvars. Simply copy terraform.tfvars.example to terraform.tfvars and edit it with the proper values.

## Planning

Terraform Enterprise uses terraform itself for deployment. Once you have filled in the `terraform.tfvars` file, simply run: `terraform plan`. This will output the manifest of all the resources that will be created.

## Deployment

Once you're ready to deploy Terraform Enterprise, run `terraform apply`. This will take approximately 10 minutes (mostly due to RDS creation time).

## Upgrade

To upgrade your instance of Terraform Enterprise, simply update the repository containing the terraform configuration, plan, and apply.
