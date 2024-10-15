
# output "ec2_public_ip" {  
#     value = module.public-EC2-M.insatance-public_ip
# }
# output "ec2-public_ips" {  
#     value = module.public-EC2-M.ec2-public_ips
# }
output "ec2_public_ips" {  
    value = module.public-EC2-M.ec2_public_ips
}
# output "Bastion_Host-ip" {
#   value = module.public-EC2-M.ec2-public_ips
# }
# # output "App_ec2-ip" {
# #   value = module.private-EC2-M.ec2-private_ip
# # }
# output "public_ec2_ids" {
#     #value = tolist([for key, value in module.public-EC2-M.ec2_ids : value.id])  
#     value = tolist(module.public-EC2-M.ec2_ids)
# }
# output "private_ec2_ids" {
#     #value = tolist([for key, value in module.private-EC2-M.ec2_ids : value.id])  
#     value = tolist(module.private-EC2-M.ec2_ids)
# }