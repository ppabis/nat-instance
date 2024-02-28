### This is needed only for the SSM agent to work
### so that we can connect to the instances without SSH

### Endpoints for AWS Systems Manager - make them accessible via
### private IP and local DNS without the need of the internet

resource "aws_security_group" "endpoints" {
  vpc_id = aws_vpc.nat-test.id
  name   = "endpoints"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.nat-test.cidr_block]
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
  count               = length(local.endpoints)
  vpc_id              = aws_vpc.nat-test.id
  service_name        = local.endpoints[count.index]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoints.id]
  subnet_ids          = [for k, v in aws_subnet.private : v.id]
  tags = {
    Name = replace(local.endpoints[count.index], "com.amazonaws.eu-central-1.", "")
  }
}

