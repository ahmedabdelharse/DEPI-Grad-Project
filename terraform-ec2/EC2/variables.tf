
variable "data-most_recent" { type = bool}
variable "data-owners" {}
variable "data-filter_name" {}
variable "data-filter_value" {}
# variable "instance-subnet_id" {}
variable "instance-type" {}
# variable "instance-a_z" {}
variable "instance-sg" {type=any} #added to fix string required
variable "instance-associate_public_ip_address" {
    type    = bool
    default = true
}
variable "instance-name" {}

# variable "isntance-info" {
#   type = map(object({
#         #instance-subnet_id = string
#        # instance-type = string
#         #instance-a_z  = string
#        # instance-sg = string
#         #instance-associate_public_ip_address = bool
#         instance-name = string
#     }))
# }
variable "instance-subnet_ids" {
    description = "List of subnet IDs"
    type = list(string)
}
#variable "public_key_location" {}
variable "key_name" {}

# variable "jump_server-user_data" {
#     # type = string
#     # default = <<EOF
#     #     #!/bin/bash
#     #     sudo apt update -y
#     #     sudo apt install nginx -y
#     #     sudo systemctl start nginx
#     #     sudo systemctl enable nginx
#     #     sudo service nginx restart
#     #     echo 'Hello, World from Jump Server-${count.index + 1} $(hostname -f) without public IP' > /var/www/html/index.html
#     # EOF 
# }
# variable "machine-user_data" {
#     # type = string
#     # default = <<EOF
#     #     #!/bin/bash
#     #     sudo apt update -y
#     #     sudo apt install nginx -y
#     #     sudo systemctl start nginx
#     #     sudo systemctl enable nginx
#     #     sudo service nginx restart
#     #     echo 'Hello, World from Machine-${count.index + 1} $(hostname -f) without public IP' > /var/www/html/index.html
#     # EOF 
# }
# #variable "user_data" {}
