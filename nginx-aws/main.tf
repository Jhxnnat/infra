terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Generate a new SSH key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key in AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "aws-deployment-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

# Save the private key locally
resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${path.module}/aws-deployment-key.pem"
  file_permission = "0400"
}

# Get the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create a Security Group for HTTP and SSH
resource "aws_security_group" "web_sg" {
  name        = "aws-deployment-sg"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_ssh"
  }
}

# Create the EC2 Instance
resource "aws_instance" "web" {
  ami                    = "ami-00de3875b03809ec5"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Nginx-Server"
  }

  # Ensure the instance accepts SSH before running Ansible
  provisioner "remote-exec" {
    inline = ["echo 'SSH is ready!'"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.ssh.private_key_pem
      host        = self.public_ip
    }
  }
}

# Create Ansible inventory file dynamically
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    ip          = aws_instance.web.public_ip
    private_key = local_sensitive_file.private_key.filename
  })
  filename = "${path.module}/ansible/inventory.ini"
}

# Run Ansible Playbook
resource "null_resource" "run_ansible" {
  depends_on = [
    aws_instance.web,
    local_file.ansible_inventory,
    local_sensitive_file.private_key
  ]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${path.module}/ansible/inventory.ini ${path.module}/ansible/nginx.yaml"
  }
}
