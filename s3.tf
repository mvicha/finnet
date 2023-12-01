# Associate the KMS key created in kms.tf file with the auth, info and customers buckets
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  for_each = var.buckets

  bucket = data.aws_s3_bucket.selected[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.sec_kms.arn
    }
  }
}

# Modify the CloudFront_S3_AllowRead.tpf file to allow CloudFront to read data from the S3 buckets
data "template_file" "cloudfront_s3_read_policy" {
  template = file("${path.module}/policies/CloudFront_S3_AllowRead.tpl")
  for_each = var.buckets
  vars = {
    bucket_arn      = each.value.bucket_arn
    cloudfront_arn  = local.cloudfront_arn
    environment     = var.environment
    service         = var.service_name
  }
}

# Associate the templated file with S3 to allow CloudFront to read data from S3 buckets
resource "aws_s3_bucket_policy" "cloudfront_s3_read_only" {
  for_each = var.buckets
  bucket = each.value.bucket_name

  policy = data.template_file.cloudfront_s3_read_policy[each.key].rendered
}