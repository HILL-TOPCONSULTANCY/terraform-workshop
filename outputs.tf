output "instance_ids" {
  value = aws_instance.devops[*].id
}

output "public_ips" {
  value = aws_instance.devops[*].public_ip
}

output "public_dns" {
  value = aws_instance.devops[*].public_dns
}
