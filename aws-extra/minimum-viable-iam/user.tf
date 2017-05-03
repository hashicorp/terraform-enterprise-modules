provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_user" "tfe" {
  name = "tfe-deploy"
  path = "/system/"
}

resource "aws_iam_access_key" "tfe" {
  user = "${aws_iam_user.tfe.name}"
}

resource "aws_iam_group" "tfe-deploy" {
  name = "tfe-deploy"
  path = "/system/"
}

resource "aws_iam_group_policy" "tfe-deploy" {
  name   = "tfe-deploy"
  group  = "${aws_iam_group.tfe-deploy.id}"
  policy = "${data.aws_iam_policy_document.mvi.json}"
}

resource "aws_iam_group_membership" "tfe-deploy" {
  name  = "tfe-deploy"
  group = "${aws_iam_group.tfe-deploy.name}"

  users = [
    "${aws_iam_user.tfe.name}",
  ]
}
