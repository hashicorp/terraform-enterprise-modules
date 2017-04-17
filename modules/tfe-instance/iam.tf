resource "aws_iam_role" "tfe_iam_role" {
  name = "tfe_iam_role-${var.installation_id}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "tfe_instance" {
  name = "tfe_instance_${var.installation_id}"
  role = "${aws_iam_role.tfe_iam_role.name}"
}

data "aws_iam_policy_document" "tfe-perms" {
  statement {
    sid    = "AllowKMSEncryptDecrypt"
    effect = "Allow"

    resources = [
      "${var.kms_key_id}",
    ]

    actions = [
      "kms:*",
    ]
  }

  statement {
    sid    = "AllowS3"
    effect = "Allow"

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*",
    ]

    actions = [
      "s3:*",
    ]
  }

  statement {
    sid    = "AllowCloudwatch"
    effect = "Allow"

    resources = ["arn:aws:logs:*:log-group:${var.hostname}*"]

    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
    ]
  }
}

resource "aws_iam_role_policy" "tfe-perms" {
  name   = "TFE-${var.installation_id}"
  role   = "${aws_iam_role.tfe_iam_role.name}"
  policy = "${data.aws_iam_policy_document.tfe-perms.json}"
}
