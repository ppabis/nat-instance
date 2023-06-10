resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.nat-test.id
  cidr_block = "10.8.2.0/24"
  availability_zone = "eu-central-1b"
}