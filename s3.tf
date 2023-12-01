# Create a random number to guarantee the S3 bucket is not going to be repeated
# When using this random number you have to lowwer case the value and display the hex propery
# lower(random_id.s3_random.hex)
resource "random_id" "s3_random" {
  byte_length = 8
} 

# Create a bucket
# This is going to be the bucket for storing either auth, info or customers information
# The bucket name is obtained from local variable modvar_bucket
resource "aws_s3_bucket" "mod_bucket" {
  bucket = local.modvar_bucket

  tags = {
    Name        = local.modvar_bucket
    Environment = var.environment
    Service     = var.service_name
  }
}

# Enable bucket versioning for rollback capabilities
resource "aws_s3_bucket_versioning" "auth_bucket_versioning" {
  bucket = aws_s3_bucket.mod_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Change bucket ownership
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.mod_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Upload index.html file to the root directory of the bucket
resource "aws_s3_object" "root_index_file" {
  bucket        = aws_s3_bucket.mod_bucket.id
  key           = "index.html"
  content       = templatefile("${path.module}/content/root_index.tpl", local.index_vars)
  content_type  = "text/html"
}

# Upload index.html file to the service path of the bucket
resource "aws_s3_object" "index_file" {
  bucket        = aws_s3_bucket.mod_bucket.id
  key           = "${var.service_name}/index.html"
  content       = templatefile("${path.module}/content/index.tpl", local.index_vars)
  content_type  = "text/html"
}
