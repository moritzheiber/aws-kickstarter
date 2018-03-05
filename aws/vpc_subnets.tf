# VPC

resource "aws_vpc" "core" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name     = "core_vpc"
    Resource = "core"
  }
}

# Subnets
resource "aws_subnet" "core_subnet_a_public" {
  vpc_id                  = "${aws_vpc.core.id}"
  cidr_block              = "10.0.0.0/22"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true

  tags {
    Name     = "core_subnet_a_public"
    Resource = "core"
    Scope    = "public"
  }
}

resource "aws_subnet" "core_subnet_b_public" {
  vpc_id                  = "${aws_vpc.core.id}"
  cidr_block              = "10.0.4.0/22"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags {
    Name     = "core_subnet_b_public"
    Resource = "core"
    Scope    = "public"
  }
}

resource "aws_subnet" "core_subnet_c_public" {
  vpc_id                  = "${aws_vpc.core.id}"
  cidr_block              = "10.0.8.0/22"
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
  map_public_ip_on_launch = true

  tags {
    Name     = "core_subnet_c_public"
    Resource = "core"
    Scope    = "public"
  }
}

# Private subnets
resource "aws_subnet" "core_subnet_a_private" {
  vpc_id            = "${aws_vpc.core.id}"
  cidr_block        = "10.0.128.0/22"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name     = "core_subnet_a_private"
    Resource = "core"
    Scope    = "private"
  }
}

resource "aws_subnet" "core_subnet_b_private" {
  vpc_id            = "${aws_vpc.core.id}"
  cidr_block        = "10.0.132.0/22"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name     = "core_subnet_b_private"
    Resource = "core"
    Scope    = "private"
  }
}

resource "aws_subnet" "core_subnet_c_private" {
  vpc_id            = "${aws_vpc.core.id}"
  cidr_block        = "10.0.136.0/22"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name     = "core_subnet_c_private"
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
resource "aws_eip" "core_nat_gw_a_eip" {
  vpc = true
}

resource "aws_eip" "core_nat_gw_b_eip" {
  vpc = true
}

resource "aws_eip" "core_nat_gw_c_eip" {
  vpc = true
}

# NAT Gateways for private subnets
resource "aws_nat_gateway" "core_nat_gw_a" {
  subnet_id     = "${aws_subnet.core_subnet_a_public.id}"
  allocation_id = "${aws_eip.core_nat_gw_a_eip.id}"

  depends_on = [
    "aws_internet_gateway.core_igw",
    "aws_eip.core_nat_gw_a_eip",
  ]
}

resource "aws_nat_gateway" "core_nat_gw_b" {
  subnet_id     = "${aws_subnet.core_subnet_b_public.id}"
  allocation_id = "${aws_eip.core_nat_gw_b_eip.id}"

  depends_on = [
    "aws_internet_gateway.core_igw",
    "aws_eip.core_nat_gw_b_eip",
  ]
}

resource "aws_nat_gateway" "core_nat_gw_c" {
  subnet_id     = "${aws_subnet.core_subnet_c_public.id}"
  allocation_id = "${aws_eip.core_nat_gw_c_eip.id}"

  depends_on = [
    "aws_internet_gateway.core_igw",
    "aws_eip.core_nat_gw_c_eip",
  ]
}

# Routes
resource "aws_route_table" "core_main_route_table" {
  vpc_id = "${aws_vpc.core.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.core_igw.id}"
  }

  tags {
    Name     = "core_main_route_table"
    Resource = "core"
  }
}

resource "aws_route_table" "core_private_route_table_a" {
  vpc_id = "${aws_vpc.core.id}"

  tags {
    Name     = "core_private_route_table_a"
    Resource = "core"
  }
}

resource "aws_route_table" "core_private_route_table_b" {
  vpc_id = "${aws_vpc.core.id}"

  tags {
    Name     = "core_private_route_table_b"
    Resource = "core"
  }
}

resource "aws_route_table" "core_private_route_table_c" {
  vpc_id = "${aws_vpc.core.id}"

  tags {
    Name     = "core_private_route_table_c"
    Resource = "core"
  }
}

resource "aws_route" "core_private_default_route_a" {
  route_table_id         = "${aws_route_table.core_private_route_table_a.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.core_nat_gw_a.id}"

  depends_on = ["aws_route_table.core_private_route_table_a"]
}

resource "aws_route" "core_private_default_route_b" {
  route_table_id         = "${aws_route_table.core_private_route_table_b.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.core_nat_gw_b.id}"

  depends_on = ["aws_route_table.core_private_route_table_a"]
}

resource "aws_route" "core_private_default_route_c" {
  route_table_id         = "${aws_route_table.core_private_route_table_c.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.core_nat_gw_c.id}"

  depends_on = ["aws_route_table.core_private_route_table_c"]
}

# Route table associations
resource "aws_main_route_table_association" "core_main_route_table_association" {
  vpc_id         = "${aws_vpc.core.id}"
  route_table_id = "${aws_route_table.core_main_route_table.id}"
}

resource "aws_route_table_association" "core_private_route_table_a_association" {
  subnet_id      = "${aws_subnet.core_subnet_a_private.id}"
  route_table_id = "${aws_route_table.core_private_route_table_a.id}"
}

resource "aws_route_table_association" "core_private_route_table_b_association" {
  subnet_id      = "${aws_subnet.core_subnet_b_private.id}"
  route_table_id = "${aws_route_table.core_private_route_table_b.id}"
}

resource "aws_route_table_association" "core_private_route_table_c_association" {
  subnet_id      = "${aws_subnet.core_subnet_c_private.id}"
  route_table_id = "${aws_route_table.core_private_route_table_c.id}"
}
