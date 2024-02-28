resource "aws_subnet" "public" {
  availability_zone       = "${var.region}${var.availability_zones[0]}"
  cidr_block              = cidrsubnet(aws_vpc.nat-test.cidr_block, 8, 0)
  vpc_id                  = aws_vpc.nat-test.id
  map_public_ip_on_launch = true
  tags                    = { Name = "Public" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.nat-test.id
  tags   = { Name = "Public" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nat-test.id
  tags   = { Name = "nat-test-igw" }
}
