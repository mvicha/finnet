This is the main project from where the CloudFront CDN project is going to be executed. The purpose of this is to create 3 different buckets for 3 different environments.

The process is going to create:
1) S3 buckets for the different services (auth, info, customers)
2) CloudFront Distribution to connect to the different services
3) Setup CloudFront and S3 security policies:
  a) S3 is not going to allow any connections from the outside world, is only going to be serving files using Signed URLs
  b) CloudFront is going to be Signing URLs to connect to S3, so the files are only going to be served through CloudFront
4) KMS is going to be setup for encrypting files in the S3 bucket

When executed the project is going to:
1) Setup a Bucket for Logging purposes
2) Setup versioning for the bucket
3) Setup the bucket ownership
4) Include s3 module to:
  a) Create Buckets for each of the services with some random names to be sure are unique
  b) Setup versioning for the bucket
  c) Setup ownership of the bucket
  d) Create index files for content delivery
5) Setup Origin Access Control for CloudFront
6) Include cloudfront module to:
  a) Create a lambda function to serve index pages in subdirectories (otherwise you get an error if you do not point to index.html)
  b) Create CloudFront distribution and associate the logging bucket, lambda functions and associate buckets to the content distribution
  c) Include security module to:
    1) Allow CloudFront to read KMS key to unencrypt S3 content
    2) Setup S3 server-side encryption
    3) Allow CloudFront to read content from S3

Instructions to execute the project:
1) terraform workspace new <name of the environment you want to run>
2) terraform init
3) terraform plan -var-file=env/<env>.tfvars -out <env>.out
4) terraform apply <env>.out

After execution the process is going to show:
cloudfront_distributions = [
  {
    "distribution_arn" = "Arn of the CloudFront distribution"
    "distribution_domain_name" = "URL to access the CloudFront distribution"
  },
]
environment = "Environment name"
oac = "ID of the Origin Access Control"
s3_buckets = [
  {
    "auth" = {
      "bucket_arn" = "Arn of the Auth Bucket"
      "bucket_domain_name" = "Domain name of the Auth Bucket"
      "bucket_name" = "Auth Bucket Name"
    }
    "customers" = {
      "bucket_arn" = "Arn of the Customers Bucket"
      "bucket_domain_name" = "Domain name of the Customers Bucket"
      "bucket_name" = "Customers Bucket Name"
    }
    "info" = {
      "bucket_arn" = "Arn of the Info Bucket"
      "bucket_domain_name" = "Domain name of the Info Bucket"
      "bucket_name" = "Info Bucket Name"
    }
  },
]

