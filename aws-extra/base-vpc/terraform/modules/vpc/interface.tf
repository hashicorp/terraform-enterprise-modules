variable "vpc_name" {
  description = "The name of the VPC"
  type        = "string"
}

variable "cidr_block" {
  description = "The VPC-wide CIDR block"
  type        = "string"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = "list"
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = "list"
}

variable "availability_zones" {
  description = "List of availability zones over which to distribute subnets"
  type        = "list"
}

variable "region" {
  description = "The AWS region where the VPC will be created"
  type        = "string"
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_availability_zones" {
  value = ["${aws_subnet.private.*.availability_zone}"]
}

output "public_availability_zones" {
  value = ["${aws_subnet.public.*.availability_zone}"]
}

output "vpc_name" {
  value = "${var.vpc_name}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "s3_vpce_id" {
  value = "${aws_vpc_endpoint.private_s3.id}"
}

output "cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}
