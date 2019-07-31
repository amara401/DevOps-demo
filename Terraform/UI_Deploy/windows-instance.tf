resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "UI_Deploy" {
  ami = "${lookup(var.WIN_AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.mykey.key_name}"
  vpc_security_group_ids = ["${aws_security_group.UI_Deploy.id}"]
  user_data = <<EOF
  <script>
  Dism /Online /Enable-Feature /FeatureName:NetFx4 /All /LimitAccess /Source:X:\sources\sxs
  Dism /Online /Enable-Feature /FeatureName:MicrosoftWindowsPowerShell /All
  </script>
  
  <powershell>
  (new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', 'c:\temp\chrome.exe');. c:\temp\chrome.exe /silent /install;rm c:\temp -rec
  (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Internet Explorer').Version
  </powershell>
  EOF
  
  connection {
    user = "${var.INSTANCE_USERNAME}"
    password = "${var.INSTANCE_PASSWORD}"
	private_key  = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
  
  provisioner "file" {
  source = "test.txt"
  destination = "C:/test.txt"
  } 
  
  tags = {
    Name = "UI_DEPLOY"
  }
}