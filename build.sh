#!/bin/bash
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install
wget https://releases.hashicorp.com/terraform/1.4.5/terraform_1.4.5_linux_amd64.zip
unzip terraform_1.4.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version


