data "template_file" "kms_default_policy" {
  template = file("${path.module}/policies/CloudFront_KMS_AllowRead.json")
  vars = {
    account_arn     = local.account_arn
    account_id      = local.account_id
    cloudfront_arn  = local.cloudfront_arn
    environment     = var.environment
    service         = var.service_name
  }
}

output "kms" {
  value = data.template_file.kms_default_policy.rendered
}

resource "aws_kms_key" "sec_kms" {
  description               = "KMS key to encrypt/decrypt S3 objects"
  deletion_window_in_days   = 10
  enable_key_rotation       = true
  key_usage                 = "ENCRYPT_DECRYPT"
  customer_master_key_spec  = "SYMMETRIC_DEFAULT"
  policy                    = data.template_file.kms_default_policy.rendered
  is_enabled                = true
}

resource "aws_kms_alias" "kms_sec_alias" {
  name          = "alias/${var.environment}-${var.service_name}"
  target_key_id = aws_kms_key.sec_kms.key_id
}