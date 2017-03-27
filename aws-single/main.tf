provider "aws" {
  region = "us-west-2"
}

variable "hostname" {
  default = "emp-test"
}

variable "zone_id" {
  default = "Z1GBAST1BIYT97" # tfedemo.io
}

variable "ami_id" {
  default = "ami-e50a8a85"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "az" {
  default = "us-west-2a"
}

variable "vpc_id" {
  default = "vpc-86aa39e1"
}

variable "cert_id" {
  default = "arn:aws:acm:us-west-2:986891699432:certificate/b1c638f7-8e99-4f4e-b26a-ce13e6264b3b" # tfedemo.io
}

variable "public_subnet_id" {
  default = "subnet-21ab6568"
}

variable "private_subnet_ids" {
  type    = "list"
  default = ["subnet-25ab656c", "subnet-607dc907"]
}

# A random identifier to use as a suffix on resource names to prevent
# collisions when multiple instances of TFE are installed in a single AWS
# account.
resource "random_id" "installation-id" {
  byte_length = 6
}

module "route53" {
  source         = "../tfe-route53"
  hostname       = "${var.hostname}"
  zone_id        = "${var.zone_id}"
  alias_dns_name = "${module.instance.dns_name}"
  alias_zone_id  = "${module.instance.zone_id}"
}

data "aws_route53_zone" "selected" {
  zone_id = "${var.zone_id}"
}

module "instance" {
  source             = "../tfe-instance"
  installation_id    = "${random_id.installation-id.hex}"
  ami_id             = "${var.ami_id}"
  instance_type      = "t2.medium"
  hostname           = "${var.hostname}.${data.aws_route53_zone.selected.name}"
  az                 = "${var.az}"
  vpc_id             = "${var.vpc_id}"
  cert_id            = "${var.cert_id}"
  public_subnet_id   = "${var.public_subnet_id}"
  private_subnet_ids = "${var.private_subnet_ids}"
  db_username        = "atlasuser"
  db_password        = "password"
  db_endpoint        = "127.0.0.1:5432"
  db_database        = "atlas_production"
  redis_host         = "127.0.0.1"
  redis_port         = "6379"
}
