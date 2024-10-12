resource "aws_lb" "alb" {
  name               = var.alb_name
  #internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = false #to make terraform able to delete lb
  #idle_timeout               = 60

  #tags = var.tags
}

# Target Group Resource
resource "aws_lb_target_group" "alb_tg" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.target_group_vpc_id
  # target_type = var.target_type #defaluts to instance

}

# Attach EC2 Instances to Target Group
resource "aws_lb_target_group_attachment" "alb_tg-attach" {
  #for_each          = toset(var.ec2_instance_ids)
  count    = length(var.ec2_instance_ids)
  target_group_arn  = aws_lb_target_group.alb_tg.arn
  target_id         = var.ec2_instance_ids[count.index]
  port              = var.target_group_port
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}