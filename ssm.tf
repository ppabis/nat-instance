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
  count               = length(local.endpoints)
  vpc_id              = aws_vpc.nat-test.id
  service_name        = local.endpoints[count.index]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoints.id]
  subnet_ids          = [aws_subnet.private-subnet.id]
  tags = {
    Name = replace(local.endpoints[count.index], "com.amazonaws.eu-central-1.", "")
  }
}

### Allow new instances to register in Systems Manager

resource "aws_iam_role" "ssm-instance" {
  name               = "SSM-Instance"
  assume_role_policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [ {
            "Action": "sts:AssumeRole",
            "Principal": { "Service": [ "ec2.amazonaws.com" ] },
            "Effect": "Allow",
            "Sid": "EC2SSM"
        } ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "SSM-ManagedInstanceCore" {
  role       = aws_iam_role.ssm-instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm-profile" {
  name = "SSM-Instance-Profile"
  role = aws_iam_role.ssm-instance.name
}