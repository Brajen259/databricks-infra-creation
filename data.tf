//Get vpc_id from parameter store

data "aws_ssm_parameter" "vpc_id" {
  name = "/infra/vpc/xxxxVPCID"
}

//Get private subnet 1 ID from parameter store

data "aws_ssm_parameter" "private_subnet1_id" {
  name = "/infra/vpc/PrivateSubnet1AID"
}

//Get private subnet 2 ID from parameter store

data "aws_ssm_parameter" "private_subnet2_id" {
  name = "/infra/vpc/xxxxPrivateSubnet2AID"
}

//Get public subnet ID from parameter store

data "aws_ssm_parameter" "private_subnet3_id" {
  name = "/infra/vpc/xxxxPrivateSubnet3AID"
}

// get the default security group using the vpc-id

data "aws_security_groups" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc_id.value]
  }
}

// get private route table ids

data "aws_route_table" "private_rts1" {
  subnet_id = data.aws_ssm_parameter.private_subnet1_id.value
}

data "aws_route_table" "private_rts2" {
  subnet_id = data.aws_ssm_parameter.private_subnet2_id.value
}

data "aws_route_table" "private_rts3" {
  subnet_id = data.aws_ssm_parameter.private_subnet3_id.value
}