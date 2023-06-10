resource "aws_instance" "nat-instance" {
  ami = data.aws_ami.amazon-linux-2023.id
  associate_public_ip_address = true
  subnet_id = aws_subnet.public-subnet.id
  instance_type = "t4g.nano"
  availability_zone = "eu-central-1b"
  vpc_security_group_ids = [aws_security_group.nat-sg.id]
  key_name = aws_key_pair.nat-kp.key_name
}

resource "aws_key_pair" "nat-kp" {
    public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "nat-sg" {
  vpc_id = aws_vpc.nat-test.id
  name = "NAT"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["158.0.0.0/8"]
  }
}

output "ip" {
  value = aws_instance.nat-instance.public_ip
}

resource "aws_network_interface" "private-sub-ni" {
  subnet_id = aws_subnet.private-subnet.id
  attachment {
    device_index = 1
    instance = aws_instance.nat-instance.id
  }
}

output "private-ip" {
  value = aws_network_interface.private-sub-ni.private_ip
}