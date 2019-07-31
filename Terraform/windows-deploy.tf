AWS_ACCESS_KEY="AKIAV2FTNHEJ3QRBJUUA"
AWS_SECRET_KEY="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"
INSTANCE_PASSWORD="Passw0rd012345"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" { 
default = "us-east-1" 
}
variable "WIN_AMIS" {
  type = "map" 
  default = { 
  us-east-1 = "ami-0eaa025a752a23c5b"
  } 
} 
variable "PATH_TO_PRIVATE_KEY" { default = "~/.ssh/id_rsa" } 
variable "PATH_TO_PUBLIC_KEY" { default = "~/.ssh/id_rsa.pub" } 
variable "INSTANCE_USERNAME" { default = "admin" } 
variable "INSTANCE_PASSWORD" { }
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
provider.tf:
provider "aws" { 
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region = "${var.AWS_REGION}" 
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
windows-instance.tf:
resource "aws_key_pair" "mykey" {
  key_name = "~/.ssh/id_rsa"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "win_example" {
  ami = "ami-0eaa025a752a23c5b"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.mykey.key_name}"
  user_data = <<EOF
  <powershell>
  net user ${var.INSTANCE_USERNAME} '${var.INSTANCE_PASSWORD}' /add /y
  net localgroup administrators ${var.INSTANCE_USERNAME} /add

  winrm quickconfig -q
  winrm set winrm/config/winrs '@{MaxMemoryPerShellMB=”300″}'
  winrm set winrm/config '@{MaxTimeoutms=”1800000″}'
  winrm set winrm/config/service '@{AllowUnencrypted=”true”}'
  winrm set winrm/config/service/auth '@{Basic=”true”}'
  
  netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
  netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow
  
  net stop winrm
  sc.exe config winrm start=auto
  net start winrm
  </powershell>
  EOF
  
  provisioner "file" {
  source = "test.txt"
  destination = "C:/test.txt"
  }
  
  connection {
  type = "winrm"
  timeout = "10m"
  user = "${var.INSTANCE_USERNAME}"
  password = "${var.INSTANCE_PASSWORD}"
  }
  vpc_security_group_ids=["${aws_security_group.allow-all.id}"]

}

output "ip" {
  value="${aws_instance.win-example.public_ip}"
}

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sg.tf:
resource "aws_security_group" "allow-all" {
  name="allow-all"
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  from_port = 0
  to_port = 6556
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
  Name = "allow-RDP"
  }
}

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "aws_key_pair" "mykey" {
  key_name = "~/.ssh/id_rsa"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "win-example" {
  ami = "${lookup(var.WIN_AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.mykey.key_name}"
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
}
