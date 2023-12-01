# Define VPC variable structure
variable "vpc" {
  type        = object({
    cidr_block            = string
    enable_dns_hostnames  = bool
  })
  description = "Variable which defines the values for VPC"
}

# Define subnet variable structure
variable "subnet" {
  type        = map(object({
      cidr_block              = string
      enable_dns_hostnames    = bool
      map_public_ip_on_launch = bool
      subnet_type             = string
      availability_zone       = string
    })
  )
  description = "Variable which defines the different types of Subnets that are going to be used"
}

# Define ami_id variable structure. Used to launch all the different instances
variable "ami_id" {
  type        = string
  default     = ""
  description = "ami_id"
}

variable "instances" {
  type        = map(object({
      subnet        = string
      instance_type = string
      user_data     = bool
    })
  )
  description = "Variable which defines the values for the different hosts that are going to be launched"
}
