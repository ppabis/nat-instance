data "aws_ssm_parameter" "AL2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

resource "aws_instance" "private-instance" {
  count                  = length(var.subnets)
  ami                    = data.aws_ssm_parameter.AL2023.value
  subnet_id              = var.subnets[count.index]
  instance_type          = "t4g.nano"
  iam_instance_profile   = aws_iam_instance_profile.ssm-profile.name # Allow connecting from Systems Manager
  vpc_security_group_ids = [var.security_groups[count.index] == null ? aws_security_group.SG[count.index].id : var.security_groups[count.index]]
  tags = {
    Name    = "Private-Instance-${count.index}"
    Project = "NAT-Test"
  }
}
