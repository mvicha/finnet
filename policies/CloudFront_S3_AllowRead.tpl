{
  "Id": "${environment}${service}AllowCloudFrontServicePrincipalReadOnly",
  "Version": "2012-10-17",
  "Statement": {
      "Sid": "${environment} ${service} AllowCloudFrontServicePrincipalReadOnly",
      "Effect": "Allow",
      "Principal": {
          "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "${bucket_arn}/*",
      "Condition": {
          "StringEquals": {
              "AWS:SourceArn": "${cloudfront_arn}"
          }
      }
  }
}