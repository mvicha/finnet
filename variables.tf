variable "vpc" {
  type        = object({
    cidr_block            = string
    enable_dns_hostnames  = bool
  })
}

variable "subnet" {
  type = map(object({
      cidr_block              = string
      enable_dns_hostnames    = bool
      map_public_ip_on_launch = bool
      subnet_type             = string
      availability_zone       = string
    })
  )
}

variable "ami_id" {
  type        = string
  default     = ""
  description = "ami_id"
}

variable "instances" {
  type = map(object({
      subnet        = string
      instance_type = string
      user_data     = bool
    })
  )
}
