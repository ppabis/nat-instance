resource "aws_vpc" "nat-test" {
  cidr_block           = "10.199.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "nat-test"
  }
}
