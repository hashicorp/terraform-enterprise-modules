variable "instance_class" {}

variable "multi_az" {}

variable "name" {}

variable "password" {}

variable "storage_gbs" {}

variable "subnet_ids" {
  type = "list"
}

variable "rds_security_groups" {}

variable "username" {}

variable "version" {}

variable "vpc_cidr" {}

variable "vpc_id" {}

variable "backup_retention_period" {}

variable "storage_type" {}

variable "kms_key_id" {}

variable "snapshot_identifier" {
  default = ""
}

variable "db_name" {
  default = "atlas_production"
}

resource "aws_db_subnet_group" "rds" {
  name        = "${var.name}"
  description = "${var.name}"
  # In order for this module to work properly with the aws-extra/base-vpc
  # module, subnet_ids needs to be wrapped in square brackets even though the
  # variable is declared as a list until https://github.com/hashicorp/terraform/issues/13103 is resolved.
  subnet_ids  = ["${var.subnet_ids}"]
}

resource "aws_security_group" "rds" {
  count = "${var.rds_security_group != "" ? 0 : 1}"
  name   = "${var.name}"
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
}

resource "aws_db_instance" "rds" {
  identifier                = "${var.name}"
  engine                    = "postgres"
  engine_version            = "${var.version}"
  multi_az                  = "${var.multi_az}"
  allocated_storage         = "${var.storage_gbs}"
  db_subnet_group_name      = "${aws_db_subnet_group.rds.name}"
  username                  = "${var.username}"
  password                  = "${var.password}"
  instance_class            = "${var.instance_class}"
  vpc_security_group_ids    = ["${coalesce(var.rds_security_groups, aws_security_group.rds.id)}"]
  backup_retention_period   = "${var.backup_retention_period}"
  storage_type              = "${var.storage_type}"
  name                      = "${var.snapshot_identifier == "" ? var.db_name : ""}"
  final_snapshot_identifier = "${var.name}"
  storage_encrypted         = true
  kms_key_id                = "${var.kms_key_id}"
  snapshot_identifier       = "${var.snapshot_identifier}"

  # After a snapshot restores, the DB name will be populated from the snapshot,
  # *but* we currently need to omit the name parameter with the ternary above.
  # To prevent the effective `name = ""` config from triggering a diff after
  # initial creation, we need to ignore changes on that field.
  #
  # After this PR lands we can revert to just a static name value, removing
  # both the ternary above and the ignore_changes below:
  #   https://github.com/hashicorp/terraform/pull/13140
  lifecycle {
    ignore_changes = ["name"]
  }

  timeouts {
    create = "2h"
  }
}

output "database" {
  value = "${aws_db_instance.rds.name}"
}

output "endpoint" {
  value = "${aws_db_instance.rds.endpoint}"
}

output "username" {
  value = "${var.username}"
}

output "password" {
  value = "${var.password}"
}

output "address" {
  value = "${aws_db_instance.rds.address}"
}
