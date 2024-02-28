data "aws_vpc" "default" { default = true }

/**
  To this security group the instances should be attached. If it's created,
  it's ID should be in the outputs.
*/
resource "aws_security_group" "security_group" {

  # If another existing SG was given, don't create this one.
  count = var.security_group == "" ? 1 : 0
  # Create in the default VPC if none was given
  vpc_id = var.vpc != "" ? var.vpc : data.aws_vpc.default.id

  name = var.name_tag
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  dynamic "ingress" {
    for_each = length(var.additional_sg) + length(var.additional_cidr) > 0 ? toset([""]) : toset([])
    content {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = var.additional_sg
      cidr_blocks     = var.additional_cidr
    }
  }

  tags = { Name = var.name_tag }
}
