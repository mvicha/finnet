# Create VPC whith values defined in variables file env/dev.tfvars
resource "aws_vpc" "this_vpc" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_hostnames = var.vpc.enable_dns_hostnames

  tags = {
    Name  = "Ansible VPC"
    Type  = "VPC"
  }
}

# Create a new Internet Gateway for Public network
resource "aws_internet_gateway" "this_igw" {
  vpc_id = aws_vpc.this_vpc.id

  tags = {
    Name  = "Ansible VPC"
    Type  = "Internet GW"
  }
}

# Create a route table for public network
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block  = var.vpc.cidr_block
    gateway_id  = "local"
  }

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.this_igw.id
  }
}

# Create all the subnets as defined in the variables file in env/dev.tfvars
resource "aws_subnet" "this_subnet" {
  vpc_id    = aws_vpc.this_vpc.id
  for_each  = var.subnet

  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  availability_zone       = each.value.availability_zone

  tags = {
    Name  = "${each.key} Ansible VPC"
    Type  = "Subnet"
  }
  depends_on = [ aws_internet_gateway.this_igw ]
}

# Create a new Elastic IP address for the Nat Gateway
resource "aws_eip" "this_eip" {
  domain                    = "vpc"

  tags = {
    Name  = "Ansible VPC"
    Type  = "Elastic IP"
  }
  depends_on                = [aws_internet_gateway.this_igw]
}

# Create a new Nat Gateway and associate the recently created Elastic IP to it
resource "aws_nat_gateway" "this_ngw" {
  allocation_id = aws_eip.this_eip.id
  subnet_id     = aws_subnet.this_subnet["pub"].id

  tags = {
    Name = "Ansible VPC"
    Type = "NAT GW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this_igw]
}

# Create a Route Table to go through the Nat Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block  = var.vpc.cidr_block
    gateway_id  = "local"
  }

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.this_ngw.id
  }
}

# Associate the Route Table to the corresponding subnets
resource "aws_route_table_association" "this_rt_association" {
  for_each = var.subnet

  subnet_id       = aws_subnet.this_subnet[each.key].id
  route_table_id  = length(regexall("pub", each.key)) > 0 ? aws_route_table.public.id : aws_route_table.private.id
}