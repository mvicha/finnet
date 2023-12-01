# Configure Terraform Required Providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB Table for keeping state locked, avoiding multiple users to run Terraform at the same time
# The Table name is defined in variables.tf
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = var.dynamodb_tfstate_lock
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}

# Create the bucket where to store Terraform tfstate files
# The bucket name is defined in env.tfvars file
resource "aws_s3_bucket" "s3_tfstate" {
  bucket = var.s3_tfstate

  tags = {
    Name        = var.s3_tfstate
  }
}

# Enable bucket versioning for tfstate files. This is strongly recommended for keeping records of the changes
resource "aws_s3_bucket_versioning" "auth_bucket_versioning" {
  bucket = aws_s3_bucket.s3_tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt the Terraform State files stored at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "auth_bucket_encryption" {
  bucket = aws_s3_bucket.s3_tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Get current sessions data
data "aws_caller_identity" "current" {}