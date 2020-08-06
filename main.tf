# Determine availability zones
data "aws_availability_zones" "available" {
}

# Determine who's running the show
data "aws_caller_identity" "current" {
}

# Determine the region
data "aws_region" "region" {
}

# Determine subnets for main asg
data "aws_subnet_ids" "eks" {
  vpc_id = var.vpc_id
  filter {
    name = "tag:role"
    values = [ var.subnet_identifier ]
  }
}

