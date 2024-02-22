data "aws_subnet" "public" {
  id = var.public_subnet
}

data "aws_subnet" "private" {
  count = length(var.private_subnet)
  id    = var.private_subnet[count.index]
}

data "aws_route_table" "private_rtb" {
  count     = length(data.aws_subnet.private)
  subnet_id = data.aws_subnet.private[count.index].id
}

locals {
  # Make route table ids a set
  private_route_tables = toset([for rt in data.aws_route_table.private_rtb : rt.id])
}

/**
  Create route in the private routing table that will route the internet traffic
  via this NAT instance.
*/

resource "aws_route" "private_public" {
  count                  = length(local.private_route_tables)
  route_table_id         = private_route_tables[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.private_eni.id
}
