variable "hostname" {
  description = "The name the cluster will be register as under the zone"
}

variable "zone_id" {
  description = "The route53 zone id to register the hostname in"
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

variable "data_subnet_ids" {
  description = "Subnets to place the data services (RDS and redis) into (2 required for availability)"
  type        = "list"
}

variable "db_password" {
  description = "RDS password to use"
}

variable "bucket_name" {
  description = "S3 bucket to store artifacts into"
}

variable "manage_bucket" {
  description = "Indicate if the S3 bucket should be created/owned by this terraform state"
  default     = true
}

variable "key_name" {
  description = "Keypair name to use when started the instances"
}

variable "db_username" {
  description = "RDS username to use"
  default     = "atlas"
}

variable "region" {
  description = "AWS region to place cluster into"
  default     = "us-west-2"
}

variable "ami_id" {
  description = "AWS region to place cluster into"
  default     = "ami-0ca12a6c"
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

variable "db_size_gb" {
  description = "Disk size of the RDS instance to create"
  default     = "80"
}

variable "db_instance_class" {
  default = "db.m4.large"
}

// Multi AZ allows database snapshots to be taken without incurring an I/O
// penalty on the  primary node. This should be `true` for production workloads.
variable "db_multi_az" {
  description = "Multi-AZ sets up a second database instance for perforance and availability"
  default     = true
}

variable "db_snapshot_identifier" {
  description = "Snapshot of database to use upon creation of RDS"
  default     = ""
}

variable "bucket_force_destroy" {
  description = "Control if terraform should destroy the S3 bucket even if there are contents. This wil destroy any backups."
  default     = false
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

resource "aws_kms_key" "key" {
  description = "TFE resource encryption key"
}

module "route53" {
  source         = "../modules/tfe-route53"
  hostname       = "${var.hostname}"
  zone_id        = "${var.zone_id}"
  alias_dns_name = "${module.instance.dns_name}"
  alias_zone_id  = "${module.instance.zone_id}"
}

data "aws_route53_zone" "selected" {
  zone_id = "${var.zone_id}"
}

module "instance" {
  source               = "../modules/tfe-instance"
  installation_id      = "${random_id.installation-id.hex}"
  ami_id               = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  hostname             = "${var.hostname}.${replace(data.aws_route53_zone.selected.name, "/.$/", "")}" # "
  az                   = "${var.az}"
  vpc_id               = "${data.aws_subnet.instance.vpc_id}"
  cert_id              = "${var.cert_id}"
  instance_subnet_id   = "${var.instance_subnet_id}"
  elb_subnet_id        = "${var.elb_subnet_id}"
  key_name             = "${var.key_name}"
  db_username          = "${var.db_username}"
  db_password          = "${var.db_password}"
  db_endpoint          = "${module.db.endpoint}"
  db_database          = "${module.db.database}"
  redis_host           = "${module.redis.host}"
  redis_port           = "${module.redis.port}"
  bucket_name          = "${var.bucket_name}"
  bucket_region        = "${var.region}"
  kms_key_id           = "${aws_kms_key.key.arn}"
  bucket_force_destroy = "${var.bucket_force_destroy}"
  manage_bucket        = "${var.manage_bucket}"
}

module "db" {
  source                  = "../modules/rds"
  instance_class          = "${var.db_instance_class}"
  multi_az                = "${var.db_multi_az}"
  name                    = "tfe-${random_id.installation-id.hex}"
  username                = "${var.db_username}"
  password                = "${var.db_password}"
  storage_gbs             = "${var.db_size_gb}"
  subnet_ids              = "${var.data_subnet_ids}"
  version                 = "9.4.7"
  vpc_cidr                = "0.0.0.0/0"
  vpc_id                  = "${data.aws_subnet.instance.vpc_id}"
  backup_retention_period = "31"
  storage_type            = "gp2"
  kms_key_id              = "${aws_kms_key.key.arn}"
  snapshot_identifier     = "${var.db_snapshot_identifier}"
}

module "redis" {
  source        = "../modules/redis"
  name          = "tfe-${random_id.installation-id.hex}"
  subnet_ids    = "${var.data_subnet_ids}"
  vpc_cidr      = "0.0.0.0/0"
  vpc_id        = "${data.aws_subnet.instance.vpc_id}"
  instance_type = "cache.m3.medium"
}

output "kms_key_id" {
  value = "${aws_kms_key.key.arn}"
}

output "hostname" {
  value = "${module.instance.hostname}"
}
