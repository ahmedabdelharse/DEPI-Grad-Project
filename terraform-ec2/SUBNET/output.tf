output "public-subnet-ids" {
    value = {for key, value in aws_subnet.subnets : key => value.id if value.map_public_ip_on_launch }  
}
output "public-subnet-ids-bh" {
    value = tolist([for key, value in aws_subnet.subnets : value.id if value.map_public_ip_on_launch ])  
}


output "private-subnet-ids" {
  value = {for key, value in aws_subnet.subnets : key => value.id if !value.map_public_ip_on_launch }
}
output "private-subnet-ids-ec2" {
   value = tolist([for key, value in aws_subnet.subnets : value.id if !value.map_public_ip_on_launch ])   
}

output "subnet-ids" {
  value = {for key, value in aws_subnet.subnets : key => value.id }
}