variable "name" {}

variable "instance_type" {
  default = "cache.m3.medium"
}

variable "subnet_ids" {
  type = "list"
}

variable "vpc_id" {}
variable "vpc_cidr" {}

variable "port" {
  default = "6379"
}

variable "disable" {
  default = false
}

resource "aws_elasticache_parameter_group" "redis" {
  count       = "${var.disable ? 0 : 1}"
  name        = "${var.name}"
  family      = "redis2.8"
  description = "${var.name} parameter group"

  parameter {
    name  = "appendfsync"
    value = "everysec"
  }

  parameter {
    name  = "appendonly"
    value = "yes"
  }
}

resource "aws_security_group" "redis" {
  count  = "${var.disable ? 0 : 1}"
  vpc_id = "${var.vpc_id}"

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "terraform-enterprise"
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  count       = "${var.disable ? 0 : 1}"
  name        = "${var.name}"
  description = "${var.name} subnet group"

  # In order for this module to work properly with the aws-extra/base-vpc
  # module, subnet_ids needs to be wrapped in square brackets even though the
  # variable is declared as a list until https://github.com/hashicorp/terraform/issues/13103 is resolved.
  subnet_ids = ["${var.subnet_ids}"]
}

resource "aws_elasticache_cluster" "redis" {
  count                = "${var.disable ? 0 : 1}"
  cluster_id           = "${format("%.*s", 20, var.name)}"               # 20 max chars
  engine               = "redis"
  engine_version       = "2.8.24"
  node_type            = "${var.instance_type}"
  port                 = "${var.port}"
  num_cache_nodes      = "1"
  parameter_group_name = "${aws_elasticache_parameter_group.redis.name}"
  subnet_group_name    = "${aws_elasticache_subnet_group.redis.name}"
  security_group_ids   = ["${aws_security_group.redis.id}"]
}

output "host" {
  value = "${join("", aws_elasticache_cluster.redis.*.cache_nodes.0.address)}"
}

output "port" {
  value = "${var.port}"
}

output "password" {
  value = ""
} # Elasticache has no auth
