resource "aws_instance" "demo" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.name]

  tags = {
    Name = "jenkins"
  }
}

resource "aws_instance" "demo" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.name]

  tags = {
    Name = "ansible"
  }
}
