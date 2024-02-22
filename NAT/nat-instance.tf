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
  user_data = <<-EOF
  #!/bin/bash
  ### IP forwarding configuration
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
  sysctl --system
  ### IPTables configuration
  yum install iptables-services -y
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
  iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
  systemctl enable iptables
  service iptables save
  ### Routing configuration
  # Add private 1 to be routed via router of current private and second interface
  %{~for cidr in setsubtract(data.aws_subnet.private[*].cidr_block, [data.aws_subnet.private[0].cidr_block])~}
  echo "${cidr}\
   via ${cidrhost(data.aws_subnet.private[0].cidr_block, 1)}\
   dev eth1" >> /etc/sysconfig/network-scripts/route-eth1
  %{~endfor~}
  systemctl restart network
  EOF
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
