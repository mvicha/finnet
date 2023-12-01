# Create a group for Terraform usage
resource "aws_iam_group" "terraform_group" {
  name = "terraform"
}

# Add current user to Terraform group
resource "aws_iam_user_group_membership" "terraform_group" {
  user = local.user_name

  groups = [
    aws_iam_group.terraform_group.name,
  ]
}

# Read the S3 policy and replace the values. Allowing 
data "template_file" "s3_policy" {
  template = file("policies/s3_policy.json")
  vars = {
    resource_arn  = "arn:aws:s3:::${var.s3_tfstate}"
    bucketName   = var.s3_tfstate
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

# Attach the S3 policy to the Terraform group
resource "aws_iam_group_policy_attachment" "group_policy_s3" {
  group      = aws_iam_group.terraform_group.name
  policy_arn = aws_iam_policy.s3_tfstate.arn
}

# Attach the DynamoDB policy to the Terraform group
resource "aws_iam_group_policy_attachment" "group_policy_dynamodb" {
  group      = aws_iam_group.terraform_group.name
  policy_arn = aws_iam_policy.dynamodb_tfstate_lock.arn
}