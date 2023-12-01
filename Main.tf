# Get current sessions data
data "aws_caller_identity" "current" {}

# Get S3 bucket information
data "aws_s3_bucket" "selected" {
  for_each = var.buckets

  bucket = each.value.bucket_name
}

# Get S3 cloudfront logging bucket information
data "aws_s3_bucket" "logging_bucket" {
  bucket = var.logging_bucket
}