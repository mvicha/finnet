This repository contains the solution to the assignment proposed by io.Finnet. It is divided in some different branches that are going to be used along the deployment.

The URL of the repository is https://github.com/mvicha/finnet.git and you can download it using the command:
git clone https://github.com/mvicha/finnet.git

The branches associated are listed above:
|-------------------------------------------------------------------------------------|
|       repository_name       |                     objective                         |
|-------------------------------------------------------------------------------------|
| Deployment                  | This is a Docker image with all the required tools to |
|                             | complete the process. The instructions on how to      |
|                             | build and use it are in the Instructions section      |
|-------------------------------------------------------------------------------------|
| initialsetup                | Setup the bases to store terraform state files in S3  |
|                             | and to allow DynamoDB lock protection                 |
|-------------------------------------------------------------------------------------|
| terraform                   | Named like this because it's mainly pure terraform.   |
|                             | Contains the main process to create the CloudFront    |
|                             | assignment solution. It does require some other       |
|                             | modules listed below.                                 |
|-------------------------------------------------------------------------------------|
| s3                          | This is a Terraform module used for S3 purposes in    |
|                             | the setup of CloudFront                               |
|-------------------------------------------------------------------------------------|
| cloudfront                  | This is a Terraform module used for CloudFront        |
|                             | purposes in the setup of CloudFront                   |
|-------------------------------------------------------------------------------------|
| policies                    | This is a module used for setting up security         |
|                             | policies during the setup of CloudFront               |
|-------------------------------------------------------------------------------------|
| ansible                     | Named like this because it's related to ansible       |
|                             | execution. It contains Terraform processes along with |
|                             | ansible exeuction.                                    |
|-------------------------------------------------------------------------------------|
| compose                     | This is the branch containing the sources for running |
|                             | the docker application with compose used by ansible   |
|-------------------------------------------------------------------------------------|


Instructions:
- To start, you will have to have docker engine installed and a working AWS account to continue with the process. Not all the resources deployed by the solution are free, so you may incur in charges. Please terminate all your instances after testing the assignment.

The first thing we are going to do is to clone the repository, switch to the Deployment branch and build the docker image to have our tool ready to be used.
$ git clone https://github.com/mvicha/finnet.git
$ cd finnet
$ git checkout Deployment
$ docker image build -t infradeployment:latest .

Now with our image ready we can launch it and start working from there. The image contains all the tools we need, so from here we will work using it and the browser.

Run the container using the following command:
$docker container run --name infradeployment --rm -it -v ${HOME}/.aws:/home/infra/.aws -v ${PWD}:/home/infra/infradeployment infradeployment:latest

Once inside the container go to the infradeployment directory
$ cd infradeployment

We will create the S3 Bucket and DynamoDB table to store our Terraform states and Lock Terraform executions, to prevent multiple users to launch Terraform at the same time. For doing this we will firstly switch to our branch.
$ git checkout initialsetup

Now we can change the name of the bucket we want to use modifying the value for s3_tfstate in the env.tfvars file. The default name should be changed:
s3_tfstate = "mfvilla-tfstate"

After changing the name we can proceed to execution:
$ terraform init
$ terraform plan -var-file=env.tfvars -out initialsetup.out

If everything looks good proceed to the creation of the resources:
$ terraform apply initialsetup.out

Having created the resources we should see the output of the DynamoDB table and the S3 bucket. Save them as we may need them for all future executions of Terraform

Also we should have a tfstate file. As we created the structure for saving the tfstate file, this state wasn't saved in S3. Save that state file, or upload it to the bucket with some name to use it in the future.

Having created the bucket we can move forward to execute our CloudFront project. For doing this we will first switch to the proper branch
$ git checkout terraform

In our previous Terraform execution we got the Bucket and DynamoDB table names to modify our Terraform files. We are going to use them for our first time. Open the file Main.tf and change the `bucket` and `dynamodb_table` values
...
  backend "s3" {
    encrypt         = true
    bucket          = "mfvilla-tfstate"
    dynamodb_table  = "terraform-state-lock-dynamo"
    key             = "terraform.tfstate"
...

As we will have multiple different environments setup, you could still save Terraform files in the same bucket under different workspaces. For that you may choose your environment and start working on it. Let's start with dev environment for testing purposes
$ workspace new dev

Now it's time to create our infrastructure
$ terraform init
$ terraform plan -var-file=env/dev.tfvars -out dev.out

If everything looks correct execute:
$ terraform apply dev.out

Once finished we will get the `distribution_domain_name` along with some other information. Copy the value of the distribution_domain_name and paste it in a browser. You should see an index page containing links to auth, info and customers.

For the rest of the environments you should repeat the process starting from creating a new workspace.

NOTE: To re-use an already created workspace you can run terraform workspace select <workspace_name>, or to list the workspaces available: terraform workspace list

Here ends the first part of the assignment. Now for the second part we should switch to the ansible branch:
$ git checkout ansible

Once again, you need to change the `bucket` and `dynamodb_table` values of your Main.tf file. After modifying those values, as you did before, you can inspect the file in env/dev.tfvars for the values that you can modify for creating the infrastructure. It's important to consider that it's not fully tested in other Regions, just in us-east-1, and it may cause some problems if region and/or AZs are modified. The proposed values should work for this assignment and are according to the requirements.

For deploying this phase we will start creating our infrastructure. As we're not going to be running this in a multi infrastructure setup as before.
$ terraform init
$ terraform plan -var-file=env/dev.tfvars -out ansible.out

If everything looks correct:
$ terraform apply ansible.out

After the execution you should see the lb_dev and lb_staging URLs along with some other information. For security purposes the ssh_key is not displayed, but you will get it saved in the directory as ssh_key. You can save it to use it in the future to connect to any of the 3 deployed hosts.

Copy the LoadBalancers URLs and paste them in a browser to see the results. You should see a site with the information required jumping between the 3 different containers running in the dev or staging hosts

Here finishes the second part of the assignment.

I hope you have enjoyed this solution. If you have any questions, suggestions or concerns, don't hesitate to contact me at mvicha@gmail.com
