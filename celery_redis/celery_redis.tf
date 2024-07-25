# celery_redis/celery_redis.tf

resource "aws_instance" "celery_redis" {
  ami           = "ami-07d20571c32ba6cdc"  # Replace with your preferred AMI
  instance_type = var.instance_type
  subnet_id     = element(var.public_subnet_ids, 0)  # Use the first public subnet
  vpc_security_group_ids = [aws_security_group.celery_redis_sg.id]

  tags = {
    Name = "celery-redis"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y python3-pip redis-server
              pip3 install celery

              # Start Redis server
              sudo systemctl start redis-server
              sudo systemctl enable redis-server

              # Add more setup commands for Celery if needed
              EOF
}

resource "aws_security_group" "celery_redis_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust to allow access only from trusted sources
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "celery-redis-sg"
  }
}

output "celery_redis_instance_id" {
  value = aws_instance.celery_redis.id
}
