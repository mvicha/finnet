terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
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

data "aws_caller_identity" "current" {}