#!/bin/bash

# Get the values from the secrets manager
databricks_account_username=$(aws secretsmanager get-secret-value --secret-id databricks-secrets-$1 --query SecretString --output text | jq -r '.DATABRICKS_ACCOUNT_USERNAME')
databricks_account_password=$(aws secretsmanager get-secret-value --secret-id databricks-secrets-$1 --query SecretString --output text | jq -r '.DATABRICKS_ACCOUNT_PASSWORD')
databricks_account_id=$(aws secretsmanager get-secret-value --secret-id databricks-secrets-$1 --query SecretString --output text | jq -r '.DATABRICKS_ACCOUNT_ID')

# Replace the value of env.tfvars username, password and ID from the value that was grabbed from AWS Secret Manager
if grep -q "^databricks_account_username" $1.tfvars; then
  sed -i "s|^databricks_account_username.*|databricks_account_username = \"${databricks_account_username}\"|" $1.tfvars
else
  echo "databricks_account_username = \"${databricks_account_username}\"" >> $1.tfvars
fi

if grep -q "^databricks_account_password" $1.tfvars; then
  sed -i "s|^databricks_account_password.*|databricks_account_password = \"${databricks_account_password}\"|" $1.tfvars
else
  echo "databricks_account_password = \"${databricks_account_password}\"" >> $1.tfvars
fi

if grep -q "^databricks_account_id" $1.tfvars; then
  sed -i "s|^databricks_account_id.*|databricks_account_id = \"${databricks_account_id}\"|" $1.tfvars
else
  echo "databricks_account_id = \"${databricks_account_id}\"" >> $1.tfvars
fi

# Run Terraform plan
terraform plan --var-file="$1.tfvars"
