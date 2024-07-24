resource "aws_nat_gateway" "nat" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public.*.id, count.index)
}

resource "aws_eip" "nat" {
  domain = "vpc"
  # other configurations
}