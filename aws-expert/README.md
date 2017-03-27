# Private Terraform Enterprise

## Delivery

The goal of this installation procedure is to setup a Terraform Enterprise cluster that is available on a DNS name that is accessed via https. This expert configuration package only configures the ELB and instance, the details about the postgesql, redis, and s3 must be provided.

The output will be variable `dns_name` output by `terraform apply`. This should be configured as the CNAME value in your DNS matching the value of `fqdn` you provide.

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

* fqdn: The name that cluster be known as. This value needs to match the DNS setup for proper operations. Example: `tfe-eng01.mycompany.io`
* cert\_id: An AWS certificate ARN. This is the certification that will be used by the ELB for the cluster. Example: `arn:aws:acm:us-west-2:241656615859:certificate/f32fa674-de62-4681-8035-21a4c81474c6`
* instance\_subnet\_id: Subnet id of the subnet that the cluster's instance will be placed into. If this is a public subnet, the instance will be assigned a public IP. This is not required as the primary cluster interface is an ELB registered with the hostname. Example: `subnet-0de26b6a`
* db\_username: Postgresql username connect as. The user must already exist. Example: `terraform`
* db\_password: Password that will be used to access RDS. Example: `databaseshavesecrets`
* db\_endpoint: Postgresql host:port to connect to. Example: `postgres01.mycompany.io:5432`
* db\_database: Postgresql database to use. This must already exist. Example: `tfe`
* redis\_host: Redis host to connect to. Example: `redis01.mycompany.io`
* bucket\_name: Name of the S3 bucket to store artifacts used by the cluster into. This bucket is automatically created. We suggest you name it `tfe-${hostname}-data`, as convention.

### Optional Variables

These variables can be populated, but they have defaults that can also be used.

* region: The AWS region to deploy into. Default: `us-west-2`
* az: The AWS availability zone to use within the region. Default: `us-west-2a`
* redis\_port: Redis port to connect to. Default: `6379`

### Populating Variables

The values for these variables should be placed into terraform.tfvars. Simply copy terraform.tfvars.example to terraform.tfvars and edit it with the proper values.


## Planning

Terraform Enterprise uses terraform itself for deployment. Once you have filled in the `terraform.tfvars` file, simply run: `terraform plan`. This will output the manifest of all the resources that will be created.

## Deployment

Once you're ready to deploy Terraform Enterprise, run `terraform apply`. This will take approximately 10 minutes (mostly due to RDS creation time).

## Upgrade

To upgrade your instance of Terraform Enterprise, simply update the repository containing the terraform configuration, plan, and apply.
