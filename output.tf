output "vpc_id" {
  value = aws_vpc.main_vpc
}

output "alb_dns_name" {
  value = aws_lb.ecs_alb.dns_name
}

output "ecs-alb" {
  value = aws_lb.ecs_alb.arn
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.rds.address
  sensitive   = true
}