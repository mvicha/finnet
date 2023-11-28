vpc = {
  cidr_block            = "10.0.0.0/16"
  enable_dns_hostnames  = true
}

subnet = {
  pub   = {
    cidr_block              = "10.0.0.0/24"
    enable_dns_hostnames    = true
    map_public_ip_on_launch = true
    subnet_type             = "pub"
    availability_zone       = "us-east-1a"
  }
  dev   = {
    cidr_block              = "10.0.1.0/24"
    enable_dns_hostnames    = true
    map_public_ip_on_launch = false
    subnet_type             = "dev"
    availability_zone       = "us-east-1a"
  }
  dev2  = {
    cidr_block              = "10.0.2.0/24"
    enable_dns_hostnames    = true
    map_public_ip_on_launch = false
    subnet_type             = "dev"
    availability_zone       = "us-east-1b"
  }
  staging  = {
    cidr_block              = "10.0.3.0/24"
    enable_dns_hostnames    = true
    map_public_ip_on_launch = false
    subnet_type             = "staging"
    availability_zone       = "us-east-1a"
  }
  staging2  = {
    cidr_block              = "10.0.4.0/24"
    enable_dns_hostnames    = true
    map_public_ip_on_launch = false
    subnet_type             = "staging"
    availability_zone       = "us-east-1b"
  }
  dev_pub   = {
    cidr_block              = "10.0.5.0/24"
    enable_dns_hostnames    = true
    map_public_ip_on_launch = true
    subnet_type             = "dev"
    availability_zone       = "us-east-1a"
  }
  dev_pub2  = {
    cidr_block              = "10.0.6.0/24"
    enable_dns_hostnames    = true
    map_public_ip_on_launch = true
    subnet_type             = "dev"
    availability_zone       = "us-east-1b"
  }
  staging_pub  = {
    cidr_block              = "10.0.7.0/24"
    enable_dns_hostnames    = true
    map_public_ip_on_launch = true
    subnet_type             = "staging"
    availability_zone       = "us-east-1a"
  }
  staging_pub2  = {
    cidr_block              = "10.0.8.0/24"
    enable_dns_hostnames    = true
    map_public_ip_on_launch = true
    subnet_type             = "staging"
    availability_zone       = "us-east-1b"
  }
}

# Amazon Linux 2
# ami_id = "ami-04c97e62cb19d53f1"
# Debina
# ami_id = "ami-058bd2d568351da34"
# Ubuntu
ami_id = "ami-0fc5d935ebf8bc3bc"

instances = {
  bastion = {
    subnet        = "pub"
    instance_type = "t2.small"
    user_data     = true
  }
  dev     = {
    subnet        = "dev"
    instance_type = "t2.medium"
    user_data     = false
  }
  staging    = {
    subnet        = "staging"
    instance_type = "t2.medium"
    user_data     = false
  }
}
