// print security group details

output "security_group_ids" {
    description = "default security group id"
    value = data.aws_security_groups.default
    sensitive = true
  
}

// Print route table details for private subnets

output "rts_private1" {
    description = "route table for private subnet 1"
    value = data.aws_route_table.private_rts1
    sensitive = true
  
}

output "rts_private2" {
    description = "route table for private subnet 2"
    value = data.aws_route_table.private_rts2
    sensitive = true
  
}

// Capture the Databricks workspace's URL.
output "databricks_host" {
  value = databricks_mws_workspaces.this.workspace_url
}


// output databricks service principal details
output "service_principal_name" {
  value = databricks_service_principal.sp.display_name
}

output "service_principal_id" {
  value = databricks_service_principal.sp.application_id
}

output "service_principal_access_token" {
  value     = databricks_obo_token.this.token_value
  sensitive = true
}