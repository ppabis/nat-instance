variable "security_groups" {
  type        = list(string)
  description = "List of security groups to attach to each instance (null to create new)"
  default     = []
}

variable "subnets" {
  type        = list(string)
  description = "List of subnets to place the instances in. This will detrmine the instance count."
  default     = []
}

variable "vpc" {
  type        = string
  description = "VPC ID to place the instances in"
}

variable "SSM-Role" {
  type        = string
  description = "IAM instance profile to use for the instances"
  default     = null
}
