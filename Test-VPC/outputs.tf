output "public-subnet" {
  value = aws_subnet.public.id
}

output "private-subnets" {
  value = [for k, v in aws_subnet.private : v.id]
}

output "private-subnet-cidrs" {
  value = [for k, v in aws_subnet.private : v.cidr_block]
}

output "private-route-tables" {
  value = aws_route_table.private[*].id
}

output "vpc" {
  value = aws_vpc.nat-test.id
}
