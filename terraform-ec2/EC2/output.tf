output "ec2-out" {
  value = aws_instance.ec2
}
output "ec2_ids" {
    value = tolist([for key, value in aws_instance.ec2 : value.id])  
}
output "ec2-public_ips" {
  value = {for key, value in aws_instance.ec2 : key => value.public_ip }
}
# output "insatance-public_ip" {
#   value = aws_instance.ec2.public_ip
# }
output "ec2-private_ip" {
  value = {for key, value in aws_instance.ec2 : key => value.private_ip }
}
# Output the list of public IPs for all EC2 instances
output "ec2_public_ips" {
  value = [for instance in aws_instance.ec2 : instance.public_ip]
}
