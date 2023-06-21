resource "aws_vpc" "ecs_vpc" {
  cidr_block = var.cidr_block

}

data "aws_availability_zones" "ecs-azs" {

}

#creating private subnets, each in a different az
resource "aws_subnet" "ecsprivate_subnet" {
  vpc_id            = aws_vpc.ecs_vpc.id
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.ecs_vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.ecs-azs.names[count.index]

}

#creating public subnets, each in a different az
resource "aws_subnet" "ecspublic_subnet" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.ecs_vpc.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.ecs-azs.names[count.index]
  map_public_ip_on_launch = true

}

#Internet Gateway for the public subnet
resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_vpc.id

}

#Route public subnet traffic through IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.ecs_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ecs_igw.id

}

resource "aws_eip" "ecs_eip" {
  count      = var.az_count
  domain        = "vpc"
  depends_on = [aws_internet_gateway.ecs_igw]
  tags = {
    Name = "Test EIP ${count.index + 1}"
  }

}

resource "aws_nat_gateway" "ecs_nat" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.ecspublic_subnet.*.id, count.index)
  allocation_id = element(aws_eip.ecs_eip.*.id, count.index)


}

resource "aws_route_table" "private_RT" {
  count  = var.az_count
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block  = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.ecs_nat.*.id, count.index)
  }

}

resource "aws_route_table_association" "private_RT_ass" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.ecsprivate_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_RT.*.id, count.index)

}
