data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "selected" {
  for_each = var.buckets

  bucket = each.value.bucket_name
}

data "aws_s3_bucket" "logging_bucket" {
  bucket = var.logging_bucket
}