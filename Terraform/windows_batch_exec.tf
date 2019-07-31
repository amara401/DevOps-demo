provider "aws" {
  region     = "us-east-2"
  access_key = "<ACCESS_KEY>"
  secret_key = "<SECURITY_KEY>"
}

# Create security group with web and ssh access
resource "aws_security_group" "UI_Deploy" {
  name = "UI_Deploy"
 
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#get the public key
resource "aws_key_pair" "mykey" {
  key_name = "~/.ssh/id_rsa"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}


# Get the AWS Microsoft Windows Server 2019 Base image
resource "aws_instance" "UI_Deploy" {
  ami = "ami-0eaa025a752a23c5b"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.mykey.key_name}"
  vpc_security_group_ids = ["${aws_security_group.UI_Deploy.id}"]
  user_data = <<EOF
  <script>
  echo Current date and time >> %SystemRoot%\Temp\test.log
  echo %DATE% %TIME% >> %SystemRoot%\Temp\test.log
  </script>
  EOF
  
  provisioner "file" {
  source = "test.txt"
  destination = "C:/test.txt"
  }

  connection {
    user         = "Administrator"
    private_key  = "${file("~/.ssh/id_rsa")}"
  }

  tags = {
    Name = "UI_PATH_DEPLOY"
  }
}
