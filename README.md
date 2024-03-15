# README #

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for? ###

* Quick summary

    Terraform code for setting up databricks workspace

* Version

    V1.0

### How do I get set up? ###

* Summary of set up

    Set up aws profiles and credentials

    Initialise terraform workspace modules

    ./init.sh workspace us-east-2

Steps

    setup aws profile  and credentials using following documentation

        AWS CLI + AWS SSO Setup 

    clone the repository into your local ( Not be needed once we have Jenkins pipeline setup)

    workspace 

        Terraform set up - ensure you have terraform set up and working on your local ( Not be needed once we have Jenkins pipeline setup)

    navigate to workspace folder and run following command to initiate terraform

        ./init.sh workspace us-east-2

        note terraform stack name is “workspace”

    Add credentials to env.tfvars file ( eg test.tfvars)
    
    run the following command to test everything is working

        terraform plan --var-file="${env}.tfvars"

    run the following command to deploy the workspace

        terraform apply --var-file="${env}.tfvars"

* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact