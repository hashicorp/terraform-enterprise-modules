variable "fqdn" {
  description = "The fully qualified domain name the cluster is accessible as"
}

variable "cert_id" {
  description = "CMS certificate ID to use for TLS attached to the ELB"
}

variable "instance_subnet_id" {
  description = "Subnet to place the instance into"
}

variable "elb_subnet_id" {
  description = "Subnet that will hold the ELB"
}

variable "rds_subnet_ids" {
  description = "Subnets to place the RDS instance into (2 required for availability)"
  type        = "list"
}

variable "db_username" {
  description = "Postgresql username to use"
}

variable "db_password" {
  description = "Postgresql password to use"
}

variable "db_endpoint" {
  description = "Postgresql host:port to connect to"
}

variable "db_database" {
  description = "Postgresql database to use"
}

variable "redis_host" {
  description = "Redis host to connect to"
}

variable "bucket_name" {
  description = "S3 bucket to store artifacts into"
}

variable "key_name" {
  description = "Keypair name to use when started the instances"
}

variable "region" {
  description = "AWS region to place cluster into"
  default     = "us-west-2"
}

variable "redis_port" {
  description = "Redis port to connect to"
  default     = 6379
}

variable "ami_id" {
  description = "AWS region to place cluster into"
  default     = "ami-d6a32cb6"
}

variable "instance_type" {
  description = "AWS instance type to use"
  default     = "m4.2xlarge"
}

variable "az" {
  description = "AWS availability zone to place instance into"
  default     = "us-west-2a"
}

data "aws_subnet" "instance" {
  id = "${var.instance_subnet_id}"
}

# A random identifier to use as a suffix on resource names to prevent
# collisions when multiple instances of TFE are installed in a single AWS
# account.
resource "random_id" "installation-id" {
  byte_length = 6
}

provider "aws" {
  region = "${var.region}"
}

module "instance" {
  source             = "../modules/tfe-instance"
  installation_id    = "${random_id.installation-id.hex}"
  ami_id             = "${var.ami_id}"
  instance_type      = "${var.instance_type}"
  hostname           = "${var.fqdn}"
  az                 = "${var.az}"
  vpc_id             = "${data.aws_subnet.instance.vpc_id}"
  cert_id            = "${var.cert_id}"
  instance_subnet_id = "${var.instance_subnet_id}"
  elb_subnet_id      = "${var.elb_subnet_id}"
  key_name           = "${var.key_name}"
  db_username        = "${var.db_username}"
  db_password        = "${var.db_password}"
  db_endpoint        = "${var.db_endpoint}"
  db_database        = "${var.db_database}"
  redis_host         = "${var.redis_host}"
  redis_port         = "${var.redis_port}"
  bucket_name        = "${var.bucket_name}"
  bucket_region      = "${var.region}"
}

output "dns_name" {
  value = "${module.instance.dns_name}"
}
