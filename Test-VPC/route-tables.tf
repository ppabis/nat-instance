resource "aws_route_table" "private" {
  count  = var.route_table_count
  vpc_id = aws_vpc.nat-test.id
}

resource "aws_route_table_association" "private" {
  for_each       = var.route_table_association
  route_table_id = aws_route_table.private[each.value].id
  subnet_id      = aws_subnet.private[each.key].id
}
