output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.this_lb_dns_name
}

output "ec2_instance_ids" {
  value = module.ec2.instance_ids
}
