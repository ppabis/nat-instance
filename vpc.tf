resource "aws_vpc" "nat-test" {
  cidr_block           = "10.8.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "nat-test"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nat-test.id
  tags = {
    Name = "igw"
  }
}

