output "distribution_domain_name" {
  value = "http://${aws_cloudfront_distribution.mod_cloudfront_distribution.domain_name}"
  description = "Distribution Name"
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.mod_cloudfront_distribution.arn
  description = "Distribution arn"
}

# output "cloudfront" {
#   value = aws_cloudfront_distribution.mod_cloudfront_distribution
# }

# output "bucket_domain_names" {
#   value = data.aws_s3_bucket.logging_bucket.*
# }
