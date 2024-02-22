data "aws_subnet" "public" {
  id = var.public_subnet
}

data "aws_subnet" "private" {
  count = length(var.private_subnet)
  id    = var.private_subnet[count.index]
}



/**
  Create route in the private routing table that will route the internet traffic
  via this NAT instance.
*/

resource "aws_route" "private_public" {
  count                  = length(var.route_tables)
  route_table_id         = var.route_tables[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.private_eni.id
}
