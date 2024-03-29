output "security_group_id" {
  description = "Attach this security group to private instances that should be able to use this NAT instance"
  value       = var.security_group != "" ? var.security_group : aws_security_group.security_group[0].id
}

output "public-nat-ip" {
  value       = var.elastic_ip ? aws_eip.public_ip[0].public_ip : aws_instance.nat_instance.public_ip
  description = "Public IP of the NAT instance if it has to be whitelisted somewhere"
}
