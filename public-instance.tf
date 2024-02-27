module "nat" {
  source         = "./NAT"
  vpc            = aws_vpc.nat-test.id
  public_subnet  = aws_subnet.public-subnet.id
  private_subnet = aws_subnet.private-subnet[*].id
  route_tables   = [aws_route_table.private-rtb.id]
  iam_profile    = aws_iam_instance_profile.ssm-profile.name
  elastic_ip     = true
}

output "public-ip" {
  value = module.nat.public-nat-ip
}
