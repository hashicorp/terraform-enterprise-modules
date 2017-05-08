# Private Terraform Enterprise

## Delivery

The goal of this installation procedure is to set up a Terraform Enterprise
cluster that is available on a DNS name that is accessed via HTTPS. This
standard configuration package uses Terraform to create both the compute and data layer resources, and optionally uses Route53 to configure the DNS automatically,

## Preflight

### Dependencies

Before setup begins, a few resources need to be provisioned. We consider these out of scope for the cluster provisioning because they depend on the user's environment.

The following are required to complete installation:

* **AWS IAM credentials** capable of creating new IAM roles configuring various services. We suggest you use an admin role for this. The credentials are only used for setup, during runtime only an assumed role is used.
* **AWS VPC** containing at least 2 subnets. These will be used to launch the cluster into. Subnets do not need to be public, but they do need an internet gateway at present.
* **SSH Key Pair** configured with AWS EC2. This will be used to configured support access to the cluster.
  * To create a new one: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
* A **Publicly Trusted TLS certificate** registered with AWS Certificate Manager. This can be one created by ACM for a hostname or the certificate can be imported into it.
  * To create a new ACM-managed cert: https://console.aws.amazon.com/acm/home#/wizard/
  * To import an existing cert: https://console.aws.amazon.com/acm/home#/importwizard/
  * *NOTE:* Certificates are per region, so be sure to create them in the same region as you'll be deploying Terraform Enterprise
  * *NOTE:* The certificate must allow the fully qualified hostname that Terraform Enterprise will be using. This means you need to decide on the value of hostname when creating the certificates and use the same value in the configuration.

The following details will be requested during the application bootstrapping process. It's helpful to have them prepared beforehand.

* **SMTP Credentials**: Terraform Enterprise requires SMTP information to send email. SMTP configuration can be skipped if necessary during the installation, but HashiCorp recommends configuring it during the initial bootstrapping process.
  * Hostname and port of SMTP service
  * Type of authentication (plain or login)
  * Username and password
  * Email address to use as the sender for emails originating from TFE
* (Optional) **Twilio Credentials**: Terraform Enterprise can use Twilio for SMS-based 2-factor authentication. If Twilio is not configurated, virtual MFA device based 2FA (e.g. Google Authenticator) will still be available.

### Required Variables

The following variables are required inputs and must be populated prior to beginning installation.

* `region`: The AWS region to deploy into.
* `ami_id`: The ID of a Terraform Enterprise Base AMI. See [`ami-ids`](../docs/ami-ids.md) to look one up.
* `fqdn`: The name that cluster be known as. This value needs to match the DNS setup for proper operations. Example: `tfe-eng01.mycompany.io`
* `cert_id`: An AWS certificate ARN. This is the certification that will be used by the ELB for the cluster. Example: `arn:aws:acm:us-west-2:241656615859:certificate/f32fa674-de62-4681-8035-21a4c81474c6`
* `instance_subnet_id`: Subnet id of the subnet that the cluster's instance will be placed into. If this is a public subnet, the instance will be assigned a public IP. This is not required as the primary cluster interface is an ELB registered with the hostname. Example: `subnet-0de26b6a`
* `elb_subnet_id`: Subnet id of the subnet that the cluster's instance will be placed into. If this is a public subnet, the instance will be assigned a public IP. This is not required as the primary cluster interface is an ELB registered with the hostname. Example: `subnet-0de26b6a`
* `data_subnet_ids`: Subnet ids that will be used to create the data services (RDS and ElastiCache) used by the cluster. There must be 2 subnet ids given for proper redundency. Example: `["subnet-0ce26b6b", "subnet-d0f35099"]`
* `db_password`: Password that will be used to access RDS. Example: `databaseshavesecrets`
* `bucket_name`: Name of the S3 bucket to store artifacts used by the cluster into. This bucket is automatically created. We suggest you name it `tfe-${hostname}-data`, as convention.
* `key_name`: Name of AWS ssh key pair that will be used. The pair needs to already exist, it will not be created.

### Optional Variables

These variables can be populated, but they have defaults that can also be used.

* `manage_bucket`: Indicate if this terraform state should create and own the bucket. Set this to false if you are reusing an existing bucket.
* `kms_key_id`: Specify the ARN for a KMS key to use rather than having one
  created automatically.
* `db_username` Username that will be used to access RDS. Default: `atlas`
* `db_size_gb` Disk size of the RDS instance to create. Default: `80`
* `db_instance_class` Instance type of the RDS instance to create. Default: `db.m4.large`
* `db_multi_az` Configure if the RDS cluster should multiple AZs to improve snapshot performance. Default: `true`
* `db_snapshot_identifier` Previously made snapshot to restore when RDS is created. This is for migration of data between clusters. Default is to create the database fresh.
* `db_name` This only needs to be set if you're migrating from an RDS instance with a different database name.
* `zone_id` The id of a Route53 zone that a record for the cluster will be installed into. Leave this blank if you need to manage DNS elsewhere. Example: `ZVEF52R7NLTW6`
* `hostname` If specifying `zone_id`, this should be set to the name that is used for the record to be registered with the zone. This value combined with the zone information will form the full DNS name for TFE. Example: `emp-test`

### Populating Variables

The values for these variables should be placed into terraform.tfvars. Simply copy terraform.tfvars.example to terraform.tfvars and edit it with the proper values.

## Planning

Terraform Enterprise uses terraform itself for deployment. Once you have filled in the `terraform.tfvars` file, simply run: `terraform plan`. This will output the manifest of all the resources that will be created.

## Deployment

Once you're ready to deploy Terraform Enterprise, run `terraform apply`. This will take approximately 10 minutes (mostly due to RDS creation time).

## Upgrade

To upgrade your instance of Terraform Enterprise, simply update the repository containing the terraform configuration, plan, and apply.

## Outputs

* `dns_name` - The DNS name of the load balancer for TFE. If you are managing
   DNS separately, you'll need to make a CNAME record from your indicated
   hostname to this value.
* `zone_id` - The Route53 Zone ID of the load balancer for TFE. If you are
   managing DNS separately but still using Route53, this value may be useful.
* `url` - The URL where TFE will become available when it boots.
