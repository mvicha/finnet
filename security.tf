module "policies" {
  source = "git::https://github.com/mvicha/finnet.git?ref=policies"

  buckets       = var.buckets
  cloudfront_id = aws_cloudfront_distribution.mod_cloudfront_distribution.id
  environment   = var.environment
  service_name  = var.service_name
}
