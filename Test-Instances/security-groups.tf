/**
  Create SG for each instance even if not used
**/
resource "aws_security_group" "SG" {
  count  = length(var.subnets)
  vpc_id = var.vpc
  name   = "SG${count.index}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
