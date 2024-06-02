output "vpc_id" {
  value = module.vpc.vpc_id
}

output "instance_ids" {
  value = aws_instance.devops.*.id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}
