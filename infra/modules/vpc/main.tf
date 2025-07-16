resource "aws_vpc" "aws_platform" {
    cidr_block           = var.vpc_cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags                 = merge(locals.common_tags, { Name = "${var.project}-vpc" })
  
}

resource "aws_internet_gateway" "aws_platform_igw" {
    vpc_id = aws_vpc.aws_platform.id
    tags   = merge(locals.common_tags, { Name = "${var.project}-igw" })
  
}

resource "aws_subnet" "public_subnet" {
    count                   = length(var.public_subnet_cidrs)
    vpc_id                  = aws_vpc.aws_platform.id
    cidr_block              = var.public_subnet_cidrs[count.index]
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = true
    tags                    = merge(locals.common_tags, { Name = "${var.project}-public-subnet-${count.index + 1}" })
  
}

resource "aws_subnet" "private_subnet" {
    count             = length(var.private_subnet_cidrs)
    vpc_id            = aws_vpc.aws_platform.id
    cidr_block        = var.private_subnet_cidrs[count.index]
    availability_zone = element(var.availability_zones, count.index)
    tags              = merge(locals.common_tags, { Name = "${var.project}-private-subnet-${count.index + 1}" })
  
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.aws_platform.id
    tags   = merge(locals.common_tags, { Name = "${var.project}-public-route-table" })

}

resource "aws_route_table_association" "public_subnet_association" {
    count          = length(var.public_subnet_cidrs)
    subnet_id      = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_route_table.id
}