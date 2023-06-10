resource "aws_instance" "private-instance" {
  count = 2
  ami = data.aws_ami.amazon-linux-2023.id
  subnet_id = aws_subnet.private-subnet.id
  instance_type = "t4g.nano"
  availability_zone = "eu-central-1b"
  iam_instance_profile = aws_iam_instance_profile.ssm-profile.name
  vpc_security_group_ids = [aws_security_group.nat-sg.id]
}

resource "aws_security_group" "private" {
  vpc_id = aws_vpc.nat-test.id
  name = "Private"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}