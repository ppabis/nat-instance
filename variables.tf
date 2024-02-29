variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-central-1"
}

variable "testing_ssm_role" {
  description = "The IAM role to use for SSM."
  type        = string
  default     = null
}
