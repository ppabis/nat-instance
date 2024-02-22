variable "custom_ami" {
  description = "Custom AMI to use for the NAT instance"
  type        = string
  default     = ""
  validation {
    condition     = can(regex("ami-[a-f0-9]{17}", var.custom_ami))
    error_message = "You must provide a valid AMI ID"
  }
}

variable "public_subnet" {
  description = "Public subnet ID to place the NAT instance in"
  type        = string
  validation {
    condition     = can(regex("subnet-[a-f0-9]{17}", var.public_subnet))
    error_message = "You must provide a valid subnet ID"
  }
}

variable "private_subnet" {
  description = "IDs of private subnets that will be routed though the instance"
  type        = list(string)
  validation {
    condition     = length(var.private_subnet) > 0
    error_message = "You must provide at least one private subnet ID"
  }
}

variable "vpc" {
  description = "VPC ID to place the NAT instance in"
  type        = string
  default     = ""
  validation {
    condition     = can(regex("vpc-[a-f0-9]{17}", var.vpc))
    error_message = "You must provide a valid VPC ID"
  }
}

variable "security_group" {
  description = "(Optional) Security Group ID to use for the NAT instance"
  type        = string
  default     = ""
}

variable "name_tag" {
  description = "Name tag for the NAT instance"
  type        = string
  default     = "NAT-Instance"
}
