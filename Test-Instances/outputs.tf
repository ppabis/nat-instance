output "instance_ids" {
  value = aws_instance.private-instance[*].id
}
