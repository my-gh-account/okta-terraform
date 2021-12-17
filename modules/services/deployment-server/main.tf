resource "aws_instance" "deployment_server" {
  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "ssh-key"
  vpc_security_group_ids      = [aws_security_group.deployment_server_sg.id]

  tags = {
    name = "Deployment-Server"
  }
}

resource "aws_security_group" "deployment_server_sg" {
  name = "deployment_server_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFnY0vRotC1QlHE/TAMNE7+Br1JcU/lxftN/nshuT5sZHQP6Iip6bm1dwxSLPulEcijhemyKwSDWq2bh672iIDPHbC/pZ+PFa/7U6AeJTyq7dTyrZia0DEl/hHsAudjxhmhfksOL1vqayP9wmnhpf0mnShkEHhvCSNjjJN3z3n9KmmW5ME+Fa8HYgAoFaHiWhz66HwwYqrskYysuS3RjPEbaWNA8VFqWIahVQueRdCSrn5SznMkNGmRW9iYeMjPQIsjqmSX+nrsOKfR6nOOrPyQ2Pf43FRjT+XLGYkZak/NyBciBO3CSQ8g58O8h0mAsELvaQk1eNNWakYHHtlfLDqw1X2LzNILEqr6nicJpTSjSMMSdUFFP5q7OlOmZoBlLz4jTfsKyM2ciyaE0YO5qXXst5M3h8uiEZfF5b32vZIW43hMEyvCUeQRnhLD8l0uhExT4IWSkg2MHC0rXMIy3tBI4aH2mC7HkHUDvvoeQFB1b7H/Fj2KUL3tjX9MfHRB65nT1mp3fT+aqMf6xSrn+LPa9dMTxXxccOZ+ly8NLsLEZ7xyuuXDxeLlT9p9dASQpPMhHzcOtsuEpuONFtaT4fq74vv4RRJISgrdwFcTfJ2hzv3ILPt5pYBG6VY27inWt8IzNQhx8ineBO9muqygKqvbbpyToSo2S1iBQtG4lSI4w== patrick@teramind.co"
   
}

output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.deployment_server.public_ip
}



