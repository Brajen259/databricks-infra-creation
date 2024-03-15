variable "env" {}
variable "region" {
  default = "us-east-2"
}

variable "state_bucket" {}
variable "databricks_account_username" {}
variable "databricks_account_password" {}
variable "databricks_account_id" {}

variable "tags" {
  default = {}
}

variable "cidr_block" {
  default = "10.4.0.0/16"
}

// See https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

locals {
  prefix = "dlt-${random_string.naming.result}-${var.env}"
}

variable "service_principal_access_token_lifetime" {
  description = "The lifetime of the service principal's access token, in seconds."
  type        = number
  default     = 4320000
}