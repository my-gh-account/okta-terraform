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
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcjRmSe6GElaE/Vlc561s+T/qAn8Y1QCLgHHOi8d0e7PRKMkXOF4cEtqtlRddVFnTLKcw7NmEcSh+O2gye6OwU2aT99UwRZXt7aOcozT8pV66zPFGI92/IN2VAPWTJsfmDe/g/8U0lWX41oeBEIMwuzZsb3TKKxcKPsXf301k6GlzNMUV7H+6sTwr/d0F/+oTtWNIr8yUjpPDIGT7/YTDSfhARbERLFBBoN1RpVI1K4JZ5ucJEKxVa7n3jZykcQUwO2d3HiJddmgNPSNce7daegFxgm7eT3jRazX/7wm8t3co1yANbhi7KZukR5/HnDQL2AvOPCR7vdd9wgBqEZrQz root@teraappliance9"
}

output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.deployment_server.public_ip
}



