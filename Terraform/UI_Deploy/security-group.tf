resource "aws_security_group" "UI_Deploy" {
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
  Name = "UI_Deploy"
  }
}