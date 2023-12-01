# Create a random number to guarantee the S3 bucket is not going to be repeated
# When using this random number you have to lowwer case the value and display the hex propery
# lower(random_id.s3_random.hex)
resource "random_id" "s3_random" {
  byte_length = 8
}

# Create a bucket for storing cloudfront logs
resource "aws_s3_bucket" "s3_cloudfront_logs" {
  bucket = "${lower(random_id.s3_random.hex)}-cloudfrontlogs"

  tags = {
    Name        = "${lower(random_id.s3_random.hex)}-cloudfrontlogs"
    Environment = var.env_environment
    Service     = "cloudfront"
  }
}

# Disable Bucket Versioning for CloudFront logs bucket
resource "aws_s3_bucket_versioning" "auth_bucket_versioning" {
  bucket = aws_s3_bucket.s3_cloudfront_logs.id

  versioning_configuration {
    status = "Disabled"
  }
}

# Enable Server-Side encryption for CloudFront logs bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.s3_cloudfront_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Set Ownership of CloudFront logs bucket
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.s3_cloudfront_logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Instantiate S3 Module
# Will create S3 buckets as defined in env/<env>.tfvars
# Going through the buckets variable:
# Key = Service Name
# Value = { bucket_name }
# Pass variables:
# service_name
# bucket_name
# environment
module "s3" {
  source = "git::https://github.com/mvicha/finnet.git?ref=s3"

  for_each = var.buckets

  service_name  = each.key
  bucket_name   = each.value.bucket_name
  environment   = var.env_environment
}
