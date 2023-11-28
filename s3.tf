resource "random_id" "s3_random" {
  byte_length = 8
}

resource "aws_s3_bucket" "s3_cloudfront_logs" {
  bucket = "${lower(random_id.s3_random.hex)}-cloudfrontlogs"

  tags = {
    Name        = "${lower(random_id.s3_random.hex)}-cloudfrontlogs"
    Environment = var.env_environment
    Service     = "cloudfront"
  }
}

resource "aws_s3_bucket_versioning" "auth_bucket_versioning" {
  bucket = aws_s3_bucket.s3_cloudfront_logs.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.s3_cloudfront_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.s3_cloudfront_logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

module "s3" {
  source = "git::https://github.com/mvicha/finnet.git?ref=s3"

  for_each = var.buckets

  service_name  = each.key
  bucket_name   = each.value.bucket_name
  environment   = var.env_environment
}
