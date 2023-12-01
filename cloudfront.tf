# Create CloudFormation function to serve index.html files automatically when not in the root directory
resource "aws_cloudfront_function" "serve_index_in_subdirs" {
  name    = "${var.environment}ServeIndexInSubdirs"
  runtime = "cloudfront-js-1.0"
  comment = "This function allows index.html to be displayed when url ends with /"
  publish = "true"
  code = file("${path.module}/includes/serve_index.js")
}

# Create CloudFormation distribution
# As there are going to be multiple origins in the distribution there are some dynamic sections that are going to allow having multiple entries
# Notes regarding variables used:
# domain_name (Obtained in s3 module and passed as variable. Using bucket_regional_domain_name for serving internally)
# origin_access_control_id (Obtained in the main terraform process and passed as variable)
# Associate the CloudFormation function to serve index.html files automatically
resource "aws_cloudfront_distribution" "mod_cloudfront_distribution" {

  dynamic "origin" {
    for_each = var.buckets

    content {
      domain_name               = data.aws_s3_bucket.selected["${origin.key}"].bucket_regional_domain_name
      origin_id                 = "${var.environment}-${origin.key}"
      origin_access_control_id  = var.oac_id
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = data.aws_s3_bucket.logging_bucket.bucket_regional_domain_name
  }

  default_cache_behavior {
    allowed_methods   = ["GET", "HEAD", "OPTIONS"]
    cached_methods    = ["GET", "HEAD"]
    target_origin_id  = "${var.environment}-${keys(var.buckets)[0]}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy  = "allow-all"
    min_ttl                 = 0
    default_ttl             = 3600
    max_ttl                 = 86400
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.buckets
    content {

      path_pattern      = "/${ordered_cache_behavior.key}/*"
      allowed_methods   = ["GET", "HEAD", "OPTIONS"]
      cached_methods    = ["GET", "HEAD", "OPTIONS"]
      target_origin_id  = "${var.environment}-${ordered_cache_behavior.key}"

      forwarded_values {
        query_string  = false
        headers       = ["Origin"]

        cookies {
          forward = "none"
        }
      }

      function_association {
        event_type    = "viewer-request"
        function_arn  = aws_cloudfront_function.serve_index_in_subdirs.arn
      }

      min_ttl                 = 0
      default_ttl             = 86400
      max_ttl                 = 31536000
      compress                = true
      viewer_protocol_policy  = "allow-all"
    }
  }

  price_class = "PriceClass_200"

  tags = {
    Environment = var.environment
    Service     = var.service_name
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
