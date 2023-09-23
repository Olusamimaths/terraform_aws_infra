locals {
  subnet_ips = {
    public_a = "172.31.48.0/24"
    public_b = "172.31.49.0/24"
    private_a = "172.31.50.0/24"
    private_b = "172.31.51.0/24"
  }
  subnets = {
    public_a = {
        cidr_block = local.subnet_ips.public_a
        availability_zone = "${data.aws_region.current.name}a"
        map_public_ip_on_launch = true
    }
    public_a = {
        cidr_block = local.subnet_ips.public_b
        availability_zone = "${data.aws_region.current.name}b"
        map_public_ip_on_launch = true
    }
    private_a = {
        cidr_block = local.subnet_ips.private_a
        availability_zone = "${data.aws_region.current.name}a"
        map_public_ip_on_launch = false
    }
    private_b = {
        cidr_block = local.subnet_ips.private_b
        availability_zone = "${data.aws_region.current.name}b"
        map_public_ip_on_launch = false
    }
  }
}

resource "aws_default_vpc" "default" {

}

data "aws_region" "current" {
}

resource "aws_subnet" "subnet" {
  for_each = local.subnets

  vpc_id = aws_default_vpc.default.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    Name = each.key
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_route_table_association" "public_a_to_default" {
  route_table_id = aws_default_vpc.default.default_route_table_id
  subnet_id = aws_subnet.subnet["public_a"].id
}

resource "aws_route_table_association" "public_b_to_default" {
  route_table_id = aws_default_vpc.default.default_route_table_id
  subnet_id = aws_subnet.subnet["public_b"].id
}

resource "aws_route_table_association" "private_a_to_private" {
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.subnet["private_a"].id
}

resource "aws_route_table_association" "private_b_to_private" {
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.subnet["private_b"].id
}