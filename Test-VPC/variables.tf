variable "region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "availability_zones" {
  description = "The availability zones to deploy to (in format a, b, e, etc.)"
  type        = list(string)
  default     = ["a", "b", "c"]
}

variable "route_table_count" {
  description = "The number of private route tables to create"
  type        = number
  default     = 2
}

variable "route_table_association" {
  description = "Which route table to associate with which AZ private subnet"
  type        = map(string)
  default = {
    "a" : 0,
    "b" : 1,
    "c" : 1
  }
}
