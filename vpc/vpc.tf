resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"

 tags = {
  Name = "terraform-lee"
 }
}

resource "aws_subnet" "public_subnet" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.0.0/24"

 availability_zone = "ap-northeast-3a" 

 tags = {
  Name = "terraform-lee-public-subnet"
 }
}

resource "aws_subnet" "private_subnet" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.1.0/24"

 tags = {
  Name = "terraform-lee-private-subnet"
 }
}

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id

  tags = {
  Name = "terraform-lee-igw"
 }
}

resource "aws_eip" "nat" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name = "terraform-lee-NAT-GW"
  }
}

resource "aws_route_table" "public" {
 vpc_id = aws_vpc.main.id

 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
 }

 tags = {
  Name = "terraform-lee-rt-public"
 }
}

resource "aws_route_table_association" "route_table_association_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
 vpc_id = aws_vpc.main.id
 tags = {
  Name = "terraform-lee-rt-private"
 }
}

resource "aws_route_table_association" "route_table_association_private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private_nat" {
  route_table_id              = aws_route_table.private.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.nat_gateway.id
}

