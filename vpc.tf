resource "aws_vpc" "nat-test" {
  cidr_block = "10.8.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
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

resource "aws_security_group" "endpoints" {
  vpc_id = aws_vpc.nat-test.id
  name = "endpoints"
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["10.8.0.0/16"]
  }
}

locals {
  endpoints = [
    "com.amazonaws.eu-central-1.ec2messages",
    "com.amazonaws.eu-central-1.ssm",
    "com.amazonaws.eu-central-1.ssmmessages"
  ]
}
resource "aws_vpc_endpoint" "endpoint" {
    count = length(local.endpoints)
    vpc_id = aws_vpc.nat-test.id
    service_name = local.endpoints[count.index]
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [aws_security_group.endpoints.id]
    subnet_ids = [aws_subnet.private-subnet.id]
    tags = {
        Name = replace(local.endpoints[count.index], "com.amazonaws.eu-central-1.", "")
    }
}