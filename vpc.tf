// Allow access to the list of AWS Availability Zones within the AWS Region that is configured in vars.tf and init.tf.
// See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
data "aws_availability_zones" "available" {}

// Create the required VPC resources in your AWS account.
// See https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
/*
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = local.prefix
  cidr = var.cidr_block
  azs  = data.aws_availability_zones.available.names
  tags = var.tags

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  create_igw           = true

  public_subnets  = [cidrsubnet(var.cidr_block, 3, 0)]
  private_subnets = [cidrsubnet(var.cidr_block, 3, 1),
                     cidrsubnet(var.cidr_block, 3, 2)]

  manage_default_security_group = true
  default_security_group_name = "${local.prefix}-sg"

  default_security_group_egress = [{
    cidr_blocks = "0.0.0.0/0"
  }]

  default_security_group_ingress = [{
    description = "Allow all internal TCP and UDP"
    self        = true
  }]
}
*/

// Create the required VPC endpoints within your AWS account.
// See https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest/submodules/vpc-endpoints
/*
module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.2.0"

  vpc_id             = data.aws_ssm_parameter.vpc_id.value
  security_group_ids = data.aws_security_groups.default.ids

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([
        data.aws_route_table.private_rts1.id,
        data.aws_route_table.private_rts2.id])
      tags            = {
        Name = "${local.prefix}-s3-vpc-endpoint"
      }
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = [data.aws_ssm_parameter.private_subnet1_id.value, data.aws_ssm_parameter.private_subnet2_id.value]
      tags                = {
        Name = "${local.prefix}-sts-vpc-endpoint"
      }
    }
  }

  tags = var.tags
}
*/

// Properly configure the VPC and subnets for Databricks within your AWS account.
// See https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_networks
resource "databricks_mws_networks" "this" {
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = "${local.prefix}-network"
  security_group_ids = data.aws_security_groups.default.ids
  subnet_ids         = [data.aws_ssm_parameter.private_subnet1_id.value, data.aws_ssm_parameter.private_subnet2_id.value, data.aws_ssm_parameter.private_subnet3_id.value]
  vpc_id             = data.aws_ssm_parameter.vpc_id.value
}