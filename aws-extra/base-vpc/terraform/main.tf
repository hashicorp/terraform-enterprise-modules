variable "region" {}

variable "vpc_name" {
  type = "string"
}

variable "cidr_block" {
  type    = "string"
  default = "172.23.0.0/16"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "zones" {}

module "vpc" {
  source = "modules/vpc"

  vpc_name = "${var.vpc_name}"

  cidr_block = "${var.cidr_block}"

  private_subnets = [
    "${cidrsubnet(var.cidr_block, 3, 5)}",
    "${cidrsubnet(var.cidr_block, 3, 6)}",
  ]

  public_subnets = [
    "${cidrsubnet(var.cidr_block, 5, 0)}",
  ]

  availability_zones = ["${data.aws_availability_zones.zones.names}"]
}

output "private_subnet_ids" {
  value = ["${module.vpc.private_subnets}"]
}

output "public_subnet_ids" {
  value = ["${module.vpc.public_subnets}"]
}

output "private_availability_zones" {
  value = ["${module.vpc.private_availability_zones}"]
}

output "public_availability_zones" {
  value = ["${module.vpc.public_availability_zones}"]
}

output "vpc_name" {
  value = "${module.vpc.vpc_name}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "s3_vpce_id" {
  value = "${module.vpc.s3_vpce_id}"
}

output "cidr_block" {
  value = "${module.vpc.cidr_block}"
}
