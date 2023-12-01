# Get current sessions data
data "aws_caller_identity" "current" {}

# Get S3 bucket information
data "aws_s3_bucket" "selected" {
  for_each = var.buckets

  bucket = each.value.bucket_name
}

# Get CloudFormation distribution information
data "aws_cloudfront_distribution" "selected" {
  id = var.cloudfront_id
}