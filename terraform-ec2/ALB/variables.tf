# ALB variables
variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}

# variable "internal" {
#   description = "Whether the ALB is internal or public"
#   type        = bool
#   default     = false
# }

variable "subnets" {
  description = "The subnets to attach to the ALB"
  type        = list(string)
}

variable "security_groups" {
  description = "The security groups to attach to the ALB"
  type        = list(string)
}
# Tags
# variable "tags" {
#   description = "A map of tags to assign to resources"
#   type        = map(string)
#   default     = {}
# }

# Target Group variables
variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}

variable "target_group_vpc_id" {
  description = "The VPC ID in which to create the target group"
  type        = string
}

variable "target_group_port" {
  description = "The port to forward to in the target group"
  type        = number
}

variable "target_group_protocol" {
  description = "The protocol for the target group"
  type        = string
  default     = "HTTP"
}

# Listener variables
variable "listener_port" {
  description = "The port for the listener"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "The protocol for the listener"
  type        = string
  default     = "HTTP"
}

# EC2 Instance attachment variables
variable "ec2_instance_ids" {
  description = "List of EC2 instance IDs to attach to the target group"
  type        = list(string)
}