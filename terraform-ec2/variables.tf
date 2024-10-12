variable "region" {}
variable "instance_type" {}
variable "vpc-cidr_block" {}
variable "vpc-name" {}
variable "subnet-info" {}
#networking
variable "default-sg-name" {}
variable "ingress_rules" {}
variable "egress_rules" {}
variable "default-rt-name" {}
variable "rt-route-cidr_block" {}
variable "igw-name" {}

# -> EC2
variable "instance-data-most_recent" {}
variable "instance-data-owners" {}
variable "instance-data-filter_name" {}
variable "instance-data-filter_value" {}
variable "private-instance-associate_public_ip_address"{}
variable "public-instance-associate_public_ip_address"{}

# # $-> ALB
# variable "alb_name" {}
# variable "alb-target_group_name" {}
# variable "alb-target_group_port" {}
# variable "alb-target_group_protocol" {}
# variable "alb-listener_port" {}
# variable "alb-listener_protocol" {}
