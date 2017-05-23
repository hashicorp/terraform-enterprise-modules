variable "hostname" {}

variable "vpc_id" {}

variable "cert_id" {}

variable "installation_id" {}

// Used for the ELB
variable "instance_subnet_id" {}

// Used for the instance
variable "elb_subnet_id" {}

variable "key_name" {}

variable "ami_id" {}

variable "instance_type" {}

variable "db_username" {}

variable "db_password" {}

variable "db_endpoint" {}

variable "db_database" {}

variable "redis_host" {}

variable "redis_port" {}

variable "kms_key_id" {}

variable "arn_partition" {
  description = "AWS partition to use (used mostly by govcloud)"
  default     = "aws"
}

variable "internal_elb" {
  default = false
}

variable "startup_script" {
  description = "Shell or other cloud-init compatible code to run on startup"
  default     = ""
}

variable "external_security_group_id" {
  description = "The ID of an existing security group to use for the ELB instead of creating one."
  default = ""
}

variable "internal_security_group_id" {
  description = "The ID of an existing security group to use for the instance instead of creating one."
  default = ""
}

resource "aws_security_group" "ptfe" {
  vpc_id = "${var.vpc_id}"
  count  = "${var.internal_security_group_id != "" ? 0 : 1}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TCP All outbound traffic
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # UDP All outbound traffic
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "terraform-enterprise"
  }
}

resource "aws_security_group" "ptfe-external" {
  count  = "${var.external_security_group_id != "" ? 0 : 1}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TCP All outbound traffic
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # UDP All outbound traffic
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "terraform-enterprise-external"
  }
}

resource "aws_launch_configuration" "ptfe" {
  image_id             = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = ["${coalesce(var.internal_security_group_id, join("", aws_security_group.ptfe.*.id))}"]
  iam_instance_profile = "${aws_iam_instance_profile.tfe_instance.name}"

  root_block_device {
    volume_size = 250
  }

  user_data = <<-BASH
#!/bin/sh

mkdir -p /etc/atlas

aws configure set s3.signature_version s3v4
aws configure set default.region ${var.bucket_region}
aws s3 cp s3://${aws_s3_bucket_object.setup.bucket}/${aws_s3_bucket_object.setup.key} /etc/atlas/boot.env

${var.startup_script}
  BASH
}

resource "aws_autoscaling_group" "ptfe" {
  # Interpolating the LC name into the ASG name here causes any changes that
  # would replace the LC (like, most commonly, an AMI ID update) to _also_
  # replace the ASG.
  name = "terraform-enterprise - ${aws_launch_configuration.ptfe.name}"

  launch_configuration  = "${aws_launch_configuration.ptfe.name}"
  desired_capacity      = 1
  min_size              = 1
  max_size              = 1
  vpc_zone_identifier   = ["${var.instance_subnet_id}"]
  load_balancers        = ["${aws_elb.ptfe.id}"]
  wait_for_elb_capacity = 1

  tag {
    key                 = "Name"
    value               = "terraform-enterprise-${var.hostname}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Hostname"
    value               = "${var.hostname}"
    propagate_at_launch = true
  }

  tag {
    key                 = "InstallationId"
    value               = "${var.installation_id}"
    propagate_at_launch = true
  }
}

resource "aws_s3_bucket_object" "setup" {
  bucket     = "${var.bucket_name}"
  key        = "tfe-setup-data"
  kms_key_id = "${var.kms_key_id}"

  # This is to make sure that the bucket exists before
  # the object is put there. We use this because the bucket
  # might not be created by TF though, just referenced.
  depends_on = ["aws_s3_bucket.tfe_bucket"]

  content = <<-BASH
DATABASE_USER="${var.db_username}"
DATABASE_PASSWORD="${var.db_password}"
DATABASE_HOST="${var.db_endpoint}"
DATABASE_DB="${var.db_database}"
REDIS_HOST="${var.redis_host}"
REDIS_PORT="${var.redis_port}"
TFE_HOSTNAME="${var.hostname}"
BUCKET_URL="${var.bucket_name}"
BUCKET_REGION="${var.bucket_region}"
KMS_KEY_ID="${var.kms_key_id}"
    BASH
}

resource "aws_elb" "ptfe" {
  internal        = "${var.internal_elb}"
  subnets         = ["${var.elb_subnet_id}"]
  security_groups = ["${coalesce(var.external_security_group_id, join("", aws_security_group.ptfe-external.*.id))}"]

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.cert_id}"
  }

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 5
  }

  tags {
    Name = "terraform-enterprise"
  }
}

output "dns_name" {
  value = "${aws_elb.ptfe.dns_name}"
}

output "zone_id" {
  value = "${aws_elb.ptfe.zone_id}"
}

output "hostname" {
  value = "${var.hostname}"
}
