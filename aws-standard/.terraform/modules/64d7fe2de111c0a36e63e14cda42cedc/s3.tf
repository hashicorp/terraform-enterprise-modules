variable "bucket_name" {}

variable "bucket_region" {}

variable "bucket_force_destroy" {
  default = false
}

variable "manage_bucket" {
  default = true
}

resource "aws_s3_bucket" "tfe_bucket" {
  count         = "${var.manage_bucket ? 1 : 0}"
  bucket        = "${var.bucket_name}"
  region        = "${var.bucket_region}"
  acl           = "private"
  force_destroy = "${var.bucket_force_destroy}"

  versioning {
    enabled = true
  }
}
