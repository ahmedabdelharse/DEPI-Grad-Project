module "VPC-M" {
    source = "./VPC"
    cidr_block = var.vpc-cidr_block
    name = var.vpc-name
}
module "SUBNET-M" {
    source = "./SUBNET"
    vpc_id = module.VPC-M.vpc-out.id
    subnet-info = var.subnet-info
}
module "NETWORKING-M" {
    source = "./NETWORKING"
    vpc_id = module.VPC-M.vpc-out.id
    default-sg-name = var.default-sg-name
    ingress_rules = var.ingress_rules
    egress_rules = var.egress_rules
    default-rt-name = var.default-rt-name
    rt-route-cidr_block = var.rt-route-cidr_block
    igw-name = var.igw-name
    prv-subnet_ids = module.SUBNET-M.private-subnet-ids-ec2
    pub-subnet_ids = module.SUBNET-M.public-subnet-ids-bh
}
module "key_pair" {
  source     = "./KEY-PAIR"
  key_name   = "Depi-app-key"
}
module "public-EC2-M" { #jump server
    source = "./EC2" 
    data-most_recent = var.instance-data-most_recent
    data-owners = var.instance-data-owners
    data-filter_name = var.instance-data-filter_name
    data-filter_value = var.instance-data-filter_value
    instance-subnet_ids = module.SUBNET-M.public-subnet-ids-bh
    instance-type = var.instance_type
    key_name = module.key_pair.key_name
    instance-sg = module.NETWORKING-M.sg-out.id
    instance-associate_public_ip_address = var.public-instance-associate_public_ip_address
    instance-name = "my-react-app-ec2"
}
resource "null_resource" "create_ansible_inventory" {
  provisioner "local-exec" {
    command = <<EOT
      echo "[ec2_instances]" > inventory.ini
      for ip in $(terraform output -json ec2_public_ips | jq -r '.[]'); do
        echo "$ip ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/Depi-app-key.pem" >> inventory.ini
      done
    EOT
  }

    depends_on = [module.public-EC2-M]  # Ensure the module runs first
}


