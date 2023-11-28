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

resource "aws_s3_bucket" "s3_tfstate" {
  bucket = var.s3_tfstate

  tags = {
    Name        = var.s3_tfstate
  }
}

resource "aws_s3_bucket_versioning" "auth_bucket_versioning" {
  bucket = aws_s3_bucket.s3_tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "auth_bucket_encryption" {
  bucket = aws_s3_bucket.s3_tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}