resource "aws_subnet" "public-subnet" {
  availability_zone       = "eu-central-1a"
  cidr_block              = "10.8.1.0/24"
  vpc_id                  = aws_vpc.nat-test.id
  map_public_ip_on_launch = true
  tags                    = { Name = "public-subnet" }
}

resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.nat-test.id
}

resource "aws_route_table_association" "public-rtb" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route" "default" {
  route_table_id         = aws_route_table.public-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
