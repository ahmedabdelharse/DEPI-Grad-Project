region = "eu-west-3"
instance_type = "t2.micro"

#-> vpc
vpc-cidr_block = "20.0.0.0/16"
vpc-name = "harse-vpc"

#-> subnet
subnet-info = {
    "public_subnet" = {
        cidr_block = "20.0.0.0/24"
        availability_zone = "eu-west-3a"
        map_public_ip_on_launch = true
        Name = "public_subnet"
    }
    "private_subnet" = {
        cidr_block = "20.0.50.0/24"
        availability_zone = "eu-west-3b"
        map_public_ip_on_launch = false
        Name = "private_subnet"
    }
}

#-> networking
default-sg-name = "harse-sg"
ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  ]
egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
default-rt-name = "harse-rt"
rt-route-cidr_block = "0.0.0.0/0"
igw-name = "harse-igw"

# -> EC2
instance-data-most_recent = true
instance-data-owners = "099720109477" #Canonical
instance-data-filter_name = "name"
instance-data-filter_value = "*/ubuntu-jammy-22.04-amd64-server-*" #ubuntu-22
private-instance-associate_public_ip_address = false
public-instance-associate_public_ip_address = true

# # $-> ALB
# alb_name = "tf-alb"
# alb-target_group_name = "tf-alb-tg"
# alb-target_group_port = 80
# alb-target_group_protocol = "HTTP"
# alb-listener_port = 80
# alb-listener_protocol = "HTTP"