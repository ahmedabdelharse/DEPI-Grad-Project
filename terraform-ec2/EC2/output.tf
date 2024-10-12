output "ec2-out" {
  value = aws_instance.ec2
}
output "ec2_ids" {
    value = tolist([for key, value in aws_instance.ec2 : value.id])  
}
output "ec2-public_ip" {
  value = aws_instance.ec2.public_ip
}
output "ec2-private_ip" {
  value = aws_instance.ec2.private_ip
}
