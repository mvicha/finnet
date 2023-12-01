# Instantiate policies module
# Pass variables:
# buckets (The name of the 3 buckets, obtained as variable from the main function, which obtained it from s3 Module)
# cloudfront_id (The CloudFront ID of the distribution created by this module)
# environment (Obtained as variable from main function)
# service_name (Obtained as variable from the main function)
module "policies" {
  source = "git::https://github.com/mvicha/finnet.git?ref=policies"

  buckets       = var.buckets
  cloudfront_id = aws_cloudfront_distribution.mod_cloudfront_distribution.id
  environment   = var.environment
  service_name  = var.service_name
}
