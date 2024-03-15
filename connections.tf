#Use s3 to store the state of the infrastructure.
#the bucket is set in init.sh
terraform {
  required_version = "~> 1.2"
  required_providers {
    aws = {
      version = "~> 4.41.0"
      source  = "hashicorp/aws"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.9.1"
    }
  }
  backend "s3" {
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}
// Initialize provider in "MWS" mode to provision the new workspace.
// alias = "mws" instructs Databricks to connect to https://accounts.cloud.databricks.com, to create
// a Databricks workspace that uses the E2 version of the Databricks on AWS platform.
// See https://registry.terraform.io/providers/databricks/databricks/latest/docs#authentication
provider "databricks" {
  alias    = "mws"
  host     = "https://accounts.cloud.databricks.com"
  username = var.databricks_account_username
  password = var.databricks_account_password
}
