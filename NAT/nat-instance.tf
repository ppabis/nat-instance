/* The purpose of this instance is to give access to the internet for private
resources running on ECS and EC2. This is for cost cutting. Production
infrastructure should use a NAT Gateway instead. */
resource "aws_instance" "nat_instance" {
  # Use either provided Security Group or the one that was created.
  vpc_security_group_ids = [var.security_group != "" ? var.security_group : aws_security_group.security_group[0].id]
  # Use either provided AMI or the latest Amazon Linux 2.
  ami                         = var.custom_ami != "" ? var.custom_ami : data.aws_ssm_parameter.AL2023.value
  instance_type               = "t4g.nano"
  subnet_id                   = data.aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile        = var.create_ssm_role ? aws_iam_instance_profile.ssm-role[0].name : null
  user_data_replace_on_change = true

  # If AMI changes, don't redeploy the instance. However, it might be a good
  # idea to update it once in a while :)
  lifecycle { ignore_changes = [ami] }

  tags = { Name = var.name_tag }

  /**
    This embedded script installs all the necessary software and configures it.
    First, it enables IP forwarding in the kernel. Also it installs tooling for
    iptables to that changes are persistent. It just routes like a typical NAT.
    The last part is the routing configuration so that packets are returned to
    a correct route.
  */
  user_data = templatefile("${path.module}/user_data.sh", {
    private_subnets : data.aws_subnet.private[*].cidr_block,
    primary_subnet : data.aws_subnet.private[0].cidr_block
  })
}

/**
  Add a secondary interface that will accept connections from the private subnet
  as the primary one is currently connected to the public subnet - Internet
  facing.
*/
resource "aws_network_interface" "private_eni" {
  subnet_id = data.aws_subnet.private[0].id
  attachment {
    device_index = 1
    instance     = aws_instance.nat_instance.id
  }
  security_groups   = [var.security_group != "" ? var.security_group : aws_security_group.security_group[0].id]
  source_dest_check = false # Important flag
  tags              = { StackName = "${var.name_tag}-priv" }
}

resource "aws_eip" "public_ip" {
  count    = var.elastic_ip ? 1 : 0
  instance = aws_instance.nat_instance.id
}
