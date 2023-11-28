This project contains a basic setup for running any other Terraform project.

The objective of this project is to create an AWS bucket where to store terraform state files and a DynamoDB table to lock executions.

To run the project you should:
1) Modify env.tfvars to include the name you would like to use to store your terraform state files
2) terraform init
3) terraform plan -var-file=env.tfvars -out plan.out
4) terraform apply plan.out

After the execution the process should display:
dynamodb_policy_arn = "Arn of the DynamoDB policy"
dynamodb_table = "Name of the DynamoDB table"
s3_bucket_name = "Name of the S3 Bucket"
s3_policy_arn = "Arn of the S3 policy"
