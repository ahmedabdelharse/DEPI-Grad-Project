variable "vpc_id" {}
variable "default-sg-name" {}
variable "rt-route-cidr_block" {}
variable "default-rt-name" {}
variable "pub-subnet_ids" {
  description = "List of subnet IDs to associate with the route table"
  type        = list(string)
  default     = []
}
variable "igw-name" {}
variable "prv-subnet_ids" {
    #description = "List of NAT subnet IDs."
    type        = list(string)
    default     = []
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}