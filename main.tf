# Fetch the latest official Canonical Ubuntu 22.04 LTS AMI in eu-west-2
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical AWS Account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group allowing HTTP (Port 80) and SSH (Port 22)
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Allow inbound HTTP and SSH traffic"

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-security-group"
  }
}

# EC2 Instance running WordPress
resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  user_data              = file("${path.module}/user_data.sh")

  tags = {
    Name = "WordPress-Server"
  }
}