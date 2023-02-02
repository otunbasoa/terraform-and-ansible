resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_route" "custom_route" {
  count                  = length(var.public_subnet_cidrs)
  route_table_id         = aws_route_table.custom_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.custom_igw.id
}

resource "aws_subnet" "custom_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
}

#resource "aws_route_table_association" "custom_route_association" {
# count          = length(var.vpc_cidr)
# subnet_id      = aws_subnet.custom_subnet[count.index].id
#route_table_id = aws_route_table.custom_route_table[count.index].id
#}
#resource "aws_route_table_association" "custom_route_association" {
# count          = min(length(var.vpc_cidr), length(aws_subnet.custom_subnet), length(aws_route_table.custom_route_table))
#subnet_id      = aws_subnet.custom_subnet[count.index].id
#route_table_id = aws_route_table.custom_route_table[count.index].id
#}

#resource "aws_route_table_association" "custom_route_association" {
# count = length(var.route_table_ids)

#subnet_id      = aws_subnet.new_subnet[count.index].id
#route_table_id = var.route_table_ids[count.index]
#}

resource "aws_route_table_association" "custom_route_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.custom_subnet[count.index].id
  route_table_id = aws_route_table.custom_route_table.id
}

