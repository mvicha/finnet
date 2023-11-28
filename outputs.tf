output "environment" {
  value       = var.env_environment
  description = "Environment"
}

output "s3_buckets" {
  value       = module.s3.*
  description = "S3 Buckets"
}

output "cloudfront_distributions" {
  value = module.cloudfront.*
}

output "oac" {
  value = aws_cloudfront_origin_access_control.cloudfront_oac.id
}