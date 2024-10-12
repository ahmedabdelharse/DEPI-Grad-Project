output "Bastion_Host-ip" {
  value = module.public-EC2-M.ec2-ip
}
output "App_ec2-ip" {
  value = module.private-EC2-M.ec2-ip
}
output "ec2_ids" {
    value = tolist([for key, value in aws_instance.ec2 : value.id])  
}