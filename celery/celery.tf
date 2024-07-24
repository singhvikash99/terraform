resource "aws_instance" "celery" {
  count         = 2
  ami           = "ami-0c55b159cbfafe1f0" # Replace with your preferred AMI
  instance_type = "t2.micro"
  subnet_id     = element(var.subnet_ids, count.index)
  security_groups = [aws_security_group.celery_sg.name]

  tags = {
    Name = "celery-worker"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y python3-pip
              pip3 install celery redis
              # Add more setup commands for Celery if needed
              EOF
}

resource "aws_security_group" "celery_sg" {
  vpc_id = var.vpc_id

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
