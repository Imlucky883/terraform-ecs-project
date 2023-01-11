resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
	Name = "Gawin-vpc"
  }
}

resource "aws_subnet" "my-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = variable.az_count
  tags = {
    Name = "Gawin's-subnet"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "Gawin's-igw"
  }
}

resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    subnet_id  = aws_subnet.my-subnet.id
    cidr_block = "10.0.1.0/24"
    
  }
  tags = {
    Name = "Gawin'-rt"
  }
}

resource "aws_route_table_association" "my-association" {
  subnet_id      = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.my-rt.id
}














