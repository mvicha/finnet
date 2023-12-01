# Configure Terraform Required Providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Set tfstate files to be stored in S3 bucket (Configured previously)
  # Replace bucket value with the initialsetup value obtained in "s3_bucket_name"
  # Replace dynamodb_table value with the initialsetup value obtained in "dynamodb_table"
  backend "s3" {
    encrypt         = true
    bucket          = "mfvilla-tfstate"
    dynamodb_table  = "terraform-state-lock-dynamo"
    key             = "terraform.tfstate"
    region          = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Get current sessions data
data "aws_caller_identity" "current" {}