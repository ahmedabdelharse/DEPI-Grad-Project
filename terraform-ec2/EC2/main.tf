data "aws_ami" "ami" {
  most_recent = var.data-most_recent
  owners      = [var.data-owners]
  filter {
    name   = var.data-filter_name
    values = [var.data-filter_value]
  }
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ami.id
  count                       = length(var.instance-subnet_ids)
  subnet_id                   = var.instance-subnet_ids[count.index]
  instance_type               = var.instance-type
  key_name                    = var.key_name
  security_groups             = [var.instance-sg]
  associate_public_ip_address = var.instance-associate_public_ip_address
  tags = {
    Name = "${var.instance-name}-${count.index + 1}"
  }
}
