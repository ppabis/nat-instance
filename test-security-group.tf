resource "aws_security_group" "Test-Security-Group" {
  vpc_id = module.test-vpc.vpc
  name   = "Test-Security-Group"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
