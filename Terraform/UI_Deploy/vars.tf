variable "AWS_REGION" { 
  default = "us-east-1" 
}

variable "WIN_AMIS" {
  type = "map" 
  default = { 
  us-east-1 = "ami-0eaa025a752a23c5b"
  ap-south-1 = "ami-028b3bf1662e6082f"
  } 
} 

variable "PATH_TO_PRIVATE_KEY" { default = "~/.ssh/id_rsa" } 
variable "PATH_TO_PUBLIC_KEY" { default = "~/.ssh/id_rsa.pub" } 
variable "INSTANCE_USERNAME" { default = "admin" } 
variable "INSTANCE_PASSWORD" { }