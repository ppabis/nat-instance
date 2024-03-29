variable "custom_ami" {
  description = "Custom AMI to use for the NAT instance"
  type        = string
  default     = ""
  validation {
    condition     = var.custom_ami == "" || can(regex("ami-[a-f0-9]{17}", var.custom_ami))
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

variable "route_tables" {
  description = "IDs of route tables that will be updated to route traffic through the NAT instance"
  type        = list(string)
  validation {
    condition     = length(var.route_tables) > 0
    error_message = "You must provide at least one route table ID"
  }

}

variable "vpc" {
  description = "VPC ID to place the NAT instance in"
  type        = string
  default     = ""
  validation {
    condition     = var.vpc == "" || can(regex("vpc-[a-f0-9]{17}", var.vpc))
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

variable "iam_profile" {
  description = "IAM instance profile to use for the NAT instance"
  type        = string
  default     = null
}

variable "create_ssm_role" {
  description = "Create an IAM role for SSM if it does not exist or is not specified"
  type        = bool
  default     = false
}

variable "elastic_ip" {
  # Elastic IP is useful to have any public IP if you stop and start the NAT instance
  # When two network interfaces are attached to an instance, stop and start will
  # not give any public IP to the instance if elastic is not used for whatever
  # reason. Public IPs are given randomly to instances that have one ENI though.
  # See here: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-instance-addressing.html#concepts-public-addresses
  description = "(Optional) Associate an Elastic IP with the NAT instance"
  type        = bool
  default     = false
}

variable "additional_sg" {
  description = "(Optional) Additional security groups to allow to use the NAT instance"
  type        = list(string)
  default     = []
}

variable "additional_cidr" {
  description = "(Optional) Additional CIDR blocks to allow to use the NAT instance"
  type        = list(string)
  default     = []
}
