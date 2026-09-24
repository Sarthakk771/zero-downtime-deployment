output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.app.dns_name
}

output "app1_public_ip" {
  description = "Public IP of application server 1"
  value       = aws_instance.app1.public_ip
}

output "app2_public_ip" {
  description = "Public IP of application server 2"
  value       = aws_instance.app2.public_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = aws_lb_target_group.app.arn
}