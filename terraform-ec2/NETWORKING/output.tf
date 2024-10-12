output "igw-out" {
  value = aws_internet_gateway.igw
}
output "sg-out" {
  value = aws_security_group.sg
}
output "pup-route_table_id" {
  description = "The ID of the route table"
  value       = aws_route_table.public_routetable[*].id
}
output "prv-route_table_id" {
  description = "The ID of the route table"
  value       = aws_route_table.private_routetable[*].id
}
output "eip_ids" {
  description = "The IDs of the Elastic IPs"
  value       = aws_eip.eip[*].id
}

output "nat_gateway_ids" {
  description = "The IDs of the NAT Gateways"
  value       = aws_nat_gateway.nat[*].id
}