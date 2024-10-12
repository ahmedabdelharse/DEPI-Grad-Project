# variable "key_name" {
#   description = "The name of the key pair."
#   type        = string
# }

# variable "public_key" {
#   description = "The public key material."
#   type        = string
# }
variable "key_name" {
  description = "Name of the key pair."
  type        = string
  default     = "Depi-Project-key"
}