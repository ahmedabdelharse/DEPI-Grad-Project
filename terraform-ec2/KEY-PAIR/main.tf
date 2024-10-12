# resource "aws_key_pair" "this" {
#   key_name   = var.key_name
#   public_key = var.public_key
# }
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a key pair to AWS
resource "aws_key_pair" "kp" {
  key_name   = var.key_name
  public_key = tls_private_key.pk.public_key_openssh

  # excute this command localy and save KeyPair to .ssh 
  provisioner "local-exec" {
    when    = create
    command = <<EOT
      echo '${tls_private_key.pk.private_key_pem}' > ~/.ssh/${var.key_name}.pem
      chmod 400 ~/.ssh/${var.key_name}.pem
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      if [ -f ~/.ssh/${self.key_name}.pem ]; then
        rm -f ~/.ssh/${self.key_name}.pem
      fi
    EOT
  }

}