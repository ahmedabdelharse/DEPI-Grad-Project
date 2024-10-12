# note-> remove unwatned output modules

output "target_group_name" {
  description = "Name of the created target group"
  value       = aws_lb_target_group.alb_tg.name
}

output "target_group_port" {
  description = "Port of the created target group"
  value       = aws_lb_target_group.alb_tg.port
}

# output "target_group_attachment_id" {
#   description = "The ID of the attached target"
#   value       = aws_lb_target_group_attachment.alb_tg-attach.id
# }
output "alb_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.alb.arn
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.alb_tg.arn
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.alb.dns_name
}
