data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "selected" {
  for_each = var.buckets

  bucket = each.value.bucket_name
}

data "aws_cloudfront_distribution" "selected" {
  id = var.cloudfront_id
}