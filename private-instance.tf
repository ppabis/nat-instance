data "aws_ssm_parameter" "AL2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

resource "aws_instance" "private-instance" {
  count                = 2
  tags                 = { Name = "Private-Instance-${count.index}" }
  ami                  = data.aws_ssm_parameter.AL2023.value
  subnet_id            = aws_subnet.private-subnet[count.index].id
  instance_type        = "t4g.nano"
  iam_instance_profile = aws_iam_instance_profile.ssm-profile.name # Allow connecting from Systems Manager
  vpc_security_group_ids = [
    aws_security_group.private.id,
    module.nat.security_group_id
  ]
}

resource "aws_security_group" "private" {
  vpc_id = aws_vpc.nat-test.id
  name   = "Private"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
