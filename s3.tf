resource "random_id" "s3_random" {
  byte_length = 8
}

resource "aws_s3_bucket" "mod_bucket" {
  bucket = local.modvar_bucket

  tags = {
    Name        = local.modvar_bucket
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_s3_bucket_versioning" "auth_bucket_versioning" {
  bucket = aws_s3_bucket.mod_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.mod_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_object" "index_file" {
  bucket        = aws_s3_bucket.mod_bucket.id
  key           = "${var.service_name}/index.html"
  content       = templatefile("${path.module}/content/index.tpl", local.index_vars)
  content_type  = "text/html"
}