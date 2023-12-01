# Modify CloudFront_KMS_AllowRead.tpl policy to allow CloudFront distribution to use keys for encryption/decryption
data "template_file" "kms_default_policy" {
  template = file("${path.module}/policies/CloudFront_KMS_AllowRead.tpl")
  vars = {
    account_arn     = local.account_arn
    account_id      = local.account_id
    cloudfront_arn  = local.cloudfront_arn
    environment     = var.environment
    service         = var.service_name
  }
}

# Create KMS key for encryption/decryption of S3 objects
# Associate the templated policy for security purposes
resource "aws_kms_key" "sec_kms" {
  description               = "KMS key to encrypt/decrypt S3 objects"
  deletion_window_in_days   = 10
  enable_key_rotation       = true
  key_usage                 = "ENCRYPT_DECRYPT"
  customer_master_key_spec  = "SYMMETRIC_DEFAULT"
  policy                    = data.template_file.kms_default_policy.rendered
  is_enabled                = true
}

# Create an alias for the KMS key
resource "aws_kms_alias" "kms_sec_alias" {
  name          = "alias/${var.environment}-${var.service_name}"
  target_key_id = aws_kms_key.sec_kms.key_id
}