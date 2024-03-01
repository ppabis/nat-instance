provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.30"
    }

    random = {
      source  = "hashicorp/random"
      version = ">=3.1"
    }
  }
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-west-2"
}
