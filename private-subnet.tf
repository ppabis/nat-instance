resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.nat-test.id
  cidr_block = "10.8.2.0/24"
  availability_zone = "eu-central-1b"
  tags = { Name = "private-subnet" }
}

resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.nat-test.id
}

resource "aws_route_table_association" "private-rtb" {
  route_table_id = aws_route_table.private-rtb.id
  subnet_id = aws_subnet.private-subnet.id
}

resource "aws_route" "private-public" {
    route_table_id = aws_route_table.private-rtb.id
    destination_cidr_block = "0.0.0.0/0"
    network_interface_id = aws_network_interface.private-sub-ni.id
  
}