data "aws_vpc" "vpc" {
  filter {
    name   = "tag:core_vpc"
    values = ["true"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:subnet_type"
    values = ["private"]
  }
}

data "aws_subnet_ids" "dmz" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:subnet_type"
    values = ["dmz"]
  }
}

resource "random_shuffle" "private_subnets" {
  input = data.aws_subnet_ids.private.ids
}

resource "random_shuffle" "dmz_subnets" {
  input = data.aws_subnet_ids.dmz.ids
}

locals {
  jenkins_subnet = random_shuffle.dmz_subnets.result[0]
}
