terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # do NOT pin a version here; let the root control versions
    }
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl enable apache2
              systemctl start apache2
              echo "Hello from $(hostname) in ${var.name_prefix}" > /var/www/html/index.html
              EOF

  tags = {
    Name = "${var.name_prefix}-web"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "${var.name_prefix}-web-sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
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
}
