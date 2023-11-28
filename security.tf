data "template_file" "s3_policy" {
  template = file("policies/s3_policy.json")
  vars = {
    resource_arn = "arn:aws:s3:::${var.s3_tfstate}"
  }
}

data "template_file" "dynamodb_policy" {
  template = file("policies/dynamodb_policy.json")
  vars = {
    resource_arn = "arn:aws:dynamodb:*:*:table/${var.dynamodb_tfstate_lock}"
  }
}

resource "aws_iam_policy" "s3_tfstate" {
  name   = "s3_tfstate_policy"
  path   = "/"
  policy = data.template_file.s3_policy.rendered
}

resource "aws_iam_policy" "dynamodb_tfstate_lock" {
  name   = "dynamodb_state_lock_policy"
  path   = "/"
  policy = data.template_file.dynamodb_policy.rendered
}