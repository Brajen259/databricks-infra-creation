// Initialize the Databricks provider in "normal" (workspace) mode.
// See https://registry.terraform.io/providers/databricks/databricks/latest/docs#authentication
provider "databricks" {
  // In workspace mode, you don't have to give providers aliases. Doing it here, however,
  // makes it easier to reference, for example when creating a Databricks personal access token
  // later in this file.
  alias = "created_workspace"
  host = databricks_mws_workspaces.this.workspace_url
  username = var.databricks_account_username
  password = var.databricks_account_password
}


//Create Service Principal with admin permission

data "databricks_group" "admins" {
  display_name = "admins"
  provider = databricks.created_workspace
  depends_on = [
    databricks_mws_workspaces.this
  ]
}

resource "databricks_service_principal" "sp" {
  display_name = "workspace-manager-sp-${var.env}"
  provider = databricks.created_workspace
  depends_on = [
    databricks_mws_workspaces.this
  ]
}

resource "databricks_group_member" "admin" {
  group_id  = data.databricks_group.admins.id
  member_id = databricks_service_principal.sp.id
  provider = databricks.created_workspace
  depends_on = [
    databricks_mws_workspaces.this
  ]

}

// assign permission to use this token to service principal
resource "databricks_permissions" "token_usage" {
  authorization    = "tokens"
  provider = databricks.created_workspace
  access_control {
    service_principal_name = databricks_service_principal.sp.application_id
    permission_level       = "CAN_USE"
  }
}

resource "databricks_obo_token" "this" {
  depends_on       = [ databricks_permissions.token_usage ]
  provider = databricks.created_workspace
  application_id   = databricks_service_principal.sp.application_id
  comment          = "Personal access token on behalf of ${databricks_service_principal.sp.display_name}"
  lifetime_seconds = var.service_principal_access_token_lifetime
}


// Add databricks secrets to to AWS Secret Manager
resource "aws_secretsmanager_secret" "databricks_secrets" {
  name       = "databricks-secrets-${var.env}"
  depends_on = [databricks_obo_token.this]
}

resource "aws_secretsmanager_secret_version" "databricks_secret_data" {
  secret_id = aws_secretsmanager_secret.databricks_secrets.id
  secret_string = jsonencode({
    DATABRICKS_SERVICE_PRINCIPAL_NAME    = databricks_service_principal.sp.display_name
    DATABRICKS_SERVICE_PRINCIPAL_ID    = databricks_service_principal.sp.application_id
    DATABRICKS_WORKSPACE_URL = databricks_mws_workspaces.this.workspace_url
    DATABRICKS_PAT = databricks_obo_token.this.token_value
    DATABRICKS_CROSSACCOUNT_ROLE_NAME = aws_iam_role.cross_account_role.name
  })
  depends_on = [aws_secretsmanager_secret.databricks_secrets]
}
