resource "aws_security_group" "sg" {
    vpc_id = var.vpc_id
    tags = {
    Name = var.default-sg-name
    }
    dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
    dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_route_table" "public_routetable" {  #make rt for private to nat, public to igw 
  vpc_id = var.vpc_id
  
  route {
    cidr_block = var.rt-route-cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_routetable"
  }
}
resource "aws_route_table" "private_routetable" {  #make rt for private to nat, public to igw 
  vpc_id = var.vpc_id
  count = length(var.prv-subnet_ids)
  route {
    cidr_block = var.rt-route-cidr_block
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  
  tags = {
    Name = "private_routetable"
  }
}
resource "aws_route_table_association" "public_dynamic_association" {
  count          = length(var.pub-subnet_ids)
  subnet_id      = var.pub-subnet_ids[count.index]
  route_table_id = aws_route_table.public_routetable.id
}
resource "aws_route_table_association" "private_dynamic_association" {
  count          = length(var.prv-subnet_ids)
  subnet_id      = var.prv-subnet_ids[count.index]
  route_table_id = aws_route_table.private_routetable[count.index].id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
  Name = var.igw-name
  }
}


resource "aws_nat_gateway" "nat" {
  count = length(var.prv-subnet_ids)

  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = var.pub-subnet_ids[count.index]
  connectivity_type = "public"

  tags = {
     Name = "nat-gateway-${count.index + 1}" 
  }
  depends_on = [ aws_eip.eip ]
}
resource "aws_eip" "eip" {
  count = length(var.prv-subnet_ids)
  tags = {Name = "nat-eip-${count.index + 1}" }
}