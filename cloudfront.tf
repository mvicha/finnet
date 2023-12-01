# Create Origin Access Control
resource "aws_cloudfront_origin_access_control" "cloudfront_oac" {
  name                              = "${var.env_environment}CloudFrontOAC"
  description                       = "OAC Policy for CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Instantiate CloudFront Module
# Pass variables:
# Environment
# Logging Bucket (Created in s3.tf file)
# Buckets (Returned from S3 Module output)
# oac_id (Origin Access Control previously created)
module "cloudfront" {
  source = "git::https://github.com/mvicha/finnet.git?ref=cloudfront"

  environment         = var.env_environment
  logging_bucket      = aws_s3_bucket.s3_cloudfront_logs.id
  buckets             = module.s3
  oac_id              = aws_cloudfront_origin_access_control.cloudfront_oac.id
}
