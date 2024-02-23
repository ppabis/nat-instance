resource "aws_subnet" "private-subnet" {
  count             = 2
  vpc_id            = aws_vpc.nat-test.id
  cidr_block        = "10.8.1${count.index}.0/24"
  availability_zone = count.index == 0 ? "eu-central-1a" : "eu-central-1b"
  tags              = { Name = "private-subnet" }
}

resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.nat-test.id
}

resource "aws_route_table_association" "private-rtb" {
  count          = length(aws_subnet.private-subnet)
  route_table_id = aws_route_table.private-rtb.id
  subnet_id      = aws_subnet.private-subnet[count.index].id
}

