This is the second assignment for the tasks proposed. Here we will create an Infrastructure in AWS to serve the dev and staging environments.

The project states that an application needs to run on 2 different environments (dev and staging) in docker.

For this assignment I have decided to create the following infrastructure:

1) A VPC with private and public subnets
2) A NAT GW for communicating private networks to the outside world
3) An Internet GW for public subnets
4) 3 Instances, from which one works as a Bastion host in a public subnet, and the 2 others are for each of the corresponding environments
5) A LoadBalancer for each of the environments to reach the web app

For deploying this infrastructure you need to run:
1) Have executed Setup project
2) Modify main.tf to include the bucket name created by Setup project
3) terraform init
4) terraform plan -var-file=env/dev.tfvars -out plan.out
5) terraform apply plan.out

NOTE:
env/dev.tfvars contains a list of variables that can be modifed to satisfy different types of requirements

The process is going to create the whole infrastructure and execute ansible after it's been setup for getting everyghing up and running. It is going to create an SSH key to connect to the different hosts and is going to establish a proxy communication between the bastion host and the environments for allowing ansible execution.

After the execution the process is going to display the following information:
BastionHostDNS = "DNS of the Bastion Host to connect to"
BastionHostIP = "IP Address of the Bastion Host to connect to"
BastionInstanceId = "Bastion Host Instance ID"
DevHost = "Private IP Address of the Dev Host"
DevHostInstanceId = "Dev Host Instance ID"
SSH_Key = <sensitive>
StagingHost = "Private IP Address of the Staging Host"
StagingHostInstanceId = "Staging Host Instance ID"
lb_dev = "Load Balancer URL for the Dev environment"
lb_staging = "Load Balancer URL for the Staging environment"

Notes:
This is planned to run in us-east-1. No other regions have been considered
