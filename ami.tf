data "aws_ami" "amazon-linux-2023" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.2023*-arm64-gp2"]
  }
  most_recent = true
}

output "ami_id" {
  value = data.aws_ami.amazon-linux-2023.id
}