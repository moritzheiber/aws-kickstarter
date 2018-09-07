# VPC

resource "aws_vpc" "core" {
  cidr_block           = "${var.vpc_cidr_range}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name     = "core_vpc"
    Resource = "core"
  }
}

# Subnets
resource "aws_subnet" "public_subnet" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.core.id}"
  cidr_block              = "${var.public_subnet_cidrs[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name     = "core_public_subnet_${replace(data.aws_availability_zones.available.names[count.index], "-", "_")}"
    Resource = "core"
    Scope    = "public"
  }
}

# Private subnets
resource "aws_subnet" "private_subnet" {
  count             = "${length(data.aws_availability_zones.available.names)}"
  vpc_id            = "${aws_vpc.core.id}"
  cidr_block        = "${var.private_subnet_cidrs[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name     = "core_private_subnet_${replace(data.aws_availability_zones.available.names[count.index], "-", "_")}"
    Resource = "core"
    Scope    = "private"
  }
}

# IGW - Internet Gateway
resource "aws_internet_gateway" "core_igw" {
  vpc_id = "${aws_vpc.core.id}"

  tags {
    Name     = "core_igw"
    Resource = "core"
  }
}

# EIPs for NAT Gateway
resource "aws_eip" "core_nat_gw_eip" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc   = true
}

# NAT Gateways for private subnets
resource "aws_nat_gateway" "core_nat_gw" {
  count         = "${length(data.aws_availability_zones.available.names)}"
  subnet_id     = "${aws_subnet.private_subnet.*.id[count.index]}"
  allocation_id = "${aws_eip.core_nat_gw_eip.*.id[count.index]}"
}

# Routes
resource "aws_route_table" "core_main_route_table" {
  vpc_id = "${aws_vpc.core.id}"

  tags {
    Name     = "core_main_route_table"
    Resource = "core"
  }
}

resource "aws_route" "core_private_default_route_a" {
  route_table_id         = "${aws_route_table.core_main_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.core_igw.id}"
}

resource "aws_route_table" "core_private_route_table" {
  count  = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.core.id}"

  tags {
    Name     = "core_private_route_table_${replace(data.aws_availability_zones.available.names[count.index], "-", "_")}"
    Resource = "core"
  }
}

resource "aws_route" "core_private_default_route" {
  count                  = "${length(data.aws_availability_zones.available.names)}"
  route_table_id         = "${aws_route_table.core_private_route_table.*.id[count.index]}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.core_nat_gw.*.id[count.index]}"
}

# Route table associations
resource "aws_main_route_table_association" "core_main_route_table_association" {
  vpc_id         = "${aws_vpc.core.id}"
  route_table_id = "${aws_route_table.core_main_route_table.id}"
}

resource "aws_route_table_association" "core_private_route_table_association" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${aws_subnet.private_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.core_private_route_table.*.id[count.index]}"
}
