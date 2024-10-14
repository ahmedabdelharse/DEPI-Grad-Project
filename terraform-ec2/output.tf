output "Bastion_Host-ip" {
  value = module.public-EC2-M.ec2-public_ip
}
output "App_ec2-ip" {
  value = module.private-EC2-M.ec2-private_ip
}
output "public_ec2_ids" {
    #value = tolist([for key, value in module.public-EC2-M.ec2_ids : value.id])  
    value = tolist(module.public-EC2-M.ec2_ids)
}
output "private_ec2_ids" {
    #value = tolist([for key, value in module.private-EC2-M.ec2_ids : value.id])  
    value = tolist(module.private-EC2-M.ec2_ids)
}