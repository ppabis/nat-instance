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
