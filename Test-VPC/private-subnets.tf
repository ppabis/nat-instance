resource "aws_subnet" "private" {
  for_each          = toset(var.availability_zones)
  cidr_block        = cidrsubnet(aws_vpc.nat-test.cidr_block, 8, parseint("${each.key}", 16))
  vpc_id            = aws_vpc.nat-test.id
  availability_zone = "${var.region}${each.key}"
  tags              = { Name = "Private-${each.key}" }
}
