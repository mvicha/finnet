module "policies" {
  source = "git::https://gitlab.mvilla.org/mvicha/tempfinnet?ref=policies"

  buckets       = var.buckets
  cloudfront_id = aws_cloudfront_distribution.mod_cloudfront_distribution.id
  environment   = var.environment
  service_name  = var.service_name
}