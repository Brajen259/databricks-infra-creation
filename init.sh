#!/bin/bash

locktable="$(aws ssm get-parameter --name '/env/shared/Terraform/LockTable' --query "Parameter.Value" --output text)"
state_bucket="$(aws ssm get-parameter --name '/env/shared/Terraform/LockBucket' --query "Parameter.Value" --output text)"
kms_arn="$(aws ssm get-parameter --name '/env/shared/Terraform/KMSKeyArn' --query "Parameter.Value" --output text)"

key_name="$1"
region="$2"

#remove existing config, if it exists, can prevent issues
if [[ -f ./.terraform/terraform.tfstate ]];
then
    echo "Removing existing config"
    rm -f "./.terraform/terraform.tfstate"
else
    echo "No existing config"
fi

terraform init \
  -backend-config="bucket=${state_bucket}" \
	-backend-config="key=${key_name}" \
	-backend-config="region=${region}" \
	-backend-config="dynamodb_table=${locktable}" \
  -backend-config="kms_key_id=${kms_arn}"
echo "Finished Terraform Init"