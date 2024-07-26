resource "aws_instance" "bastion" {
  ami           = "ami-07d20571c32ba6cdc" # Replace with your preferred AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id
  key_name      = "my-keypair" # Replace with your key name

  tags = {
    Name = "bastion-host"
  }
}
