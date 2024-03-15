pipeline {
    agent none
    environment {
        ARTIFACTS_BUCKET = 'xxxx-artifacts'
        STACK_NAME = 'respawned-services'
    }
    stages {
        stage('Build') {
            options { timeout(time: 60, unit: 'MINUTES') }
            agent { label 'aws.ec2.internal.useast2.build' }
            environment {
                env = 'build'
                AWS_DEFAULT_REGION = 'us-east-2'
            }
            steps {
                echo './build.sh'
            }
        }
        stage('Dev Deployment') {
            when {
                 anyOf {
                    branch pattern: 'feature/*'
                    branch pattern: 'bug/*'
                }
                beforeAgent true
                }
                options { timeout(time: 7, unit: 'DAYS') }
                failFast true
                parallel {
                    stage('Terraform deploy') {
                        stages {
                            stage('Plan'){
                                agent { label 'aws.ec2.dev.useast2.build' }
                                environment {
                                    env = 'dev'
                                    AWS_DEFAULT_REGION = 'us-east-2'
                                }
                                input {
                                    message "Terraform plan to Dev?"
                                    ok "Do it!"
                                    id "dev"
                                    submitterParameter "APPROVED_BY"
                                }
                                steps {
                                    sh script: 'workspace/build.sh', label: "Installing Terraform CI"
                                    dir("$WORKSPACE/workspace"){
                                        sh script: './init.sh workspace us-east-2', label: "Terraform init"
                                        sh script: './terraform_plan.sh ${env}', label: "Terraform plan"
                                    }
                                }
                            }
                            stage('Apply'){
                                agent { label 'aws.ec2.dev.useast2.build' }
                                environment {
                                    env = 'dev'
                                    AWS_DEFAULT_REGION = 'us-east-2'
                                }
                                input {
                                    message "Terraform apply to Dev?"
                                    ok "Do it!"
                                    id "dev"
                                    submitterParameter "APPROVED_BY"
                                }
                                steps {
                                    sh script: 'workspace/build.sh', label: "Installing Terraform CI"
                                    dir("$WORKSPACE/workspace"){
                                        sh script: './init.sh workspace us-east-2', label: "Terraform init"
                                        sh script: './terraform_apply.sh ${env}', label: "Terraform Apply"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        stage('Test Deployment') {
            when {
                 anyOf {
                    branch pattern: 'feature/*'
                    branch pattern: 'bug/*'
                }
                beforeAgent true
                }
                options { timeout(time: 7, unit: 'DAYS') }
                failFast true
                parallel {
                    stage('Terraform deploy') {
                        stages {
                            stage('Plan'){
                                agent { label 'aws.ec2.test.useast2.build' }
                                environment {
                                    env = 'test'
                                    AWS_DEFAULT_REGION = 'us-east-2'
                                }
                                input {
                                    message "Terraform plan to Test?"
                                    ok "Do it!"
                                    id "test"
                                    submitterParameter "APPROVED_BY"
                                }
                                steps {
                                    sh script: 'workspace/build.sh', label: "Installing Terraform CI"
                                    dir("$WORKSPACE/workspace"){
                                        sh script: './init.sh workspace us-east-2', label: "Terraform init"
                                        sh script: './terraform_plan.sh ${env}', label: "Terraform plan"
                                    }
                                }
                            }
                            stage('Apply'){
                                agent { label 'aws.ec2.test.useast2.build' }
                                environment {
                                    env = 'test'
                                    AWS_DEFAULT_REGION = 'us-east-2'
                                }
                                input {
                                    message "Terraform apply to Test?"
                                    ok "Do it!"
                                    id "test"
                                    submitterParameter "APPROVED_BY"
                                }
                                steps {
                                    sh script: 'workspace/build.sh', label: "Installing Terraform CI"
                                    dir("$WORKSPACE/workspace"){
                                        sh script: './init.sh workspace us-east-2', label: "Terraform init"
                                        sh script: './terraform_apply.sh ${env}', label: "Terraform Apply"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        stage('Production Deployments') {
            when {
                branch 'master'
                beforeAgent true
            }
            options { timeout(time: 7, unit: 'DAYS') }
            failFast true
            parallel {
                stage('Terraform deployment') {
                    stages {
                            stage('Plan'){
                                agent { label 'aws.ec2.produs.useast2.build' }
                                environment {
                                    env = 'produs'
                                    AWS_DEFAULT_REGION = 'us-east-2'
                                }
                                input {
                                    message "Terraform plan to Produs?"
                                    ok "Do it!"
                                    id "produs"
                                    submitterParameter "APPROVED_BY"
                                }
                                steps {
                                    sh script: 'workspace/build.sh', label: "Installing Terraform CI"
                                    dir("$WORKSPACE/workspace"){
                                        sh script: './init.sh workspace us-east-2', label: "Terraform init"
                                        sh script: './terraform_plan.sh ${env}', label: "Terraform plan"
                                    }
                                }
                            }
                            stage('Apply'){
                                agent { label 'aws.ec2.produs.useast2.build' }
                                environment {
                                    env = 'produs'
                                    AWS_DEFAULT_REGION = 'us-east-2'
                                }
                                input {
                                    message "Terraform apply to Dev?"
                                    ok "Do it!"
                                    id "produs"
                                    submitterParameter "APPROVED_BY"
                                }
                                steps {
                                    sh script: 'workspace/build.sh', label: "Installing Terraform CI"
                                    dir("$WORKSPACE/workspace"){
                                        sh script: './init.sh workspace us-east-2', label: "Terraform init"
                                        sh script: './terraform_apply.sh ${env}', label: "Terraform Apply"
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
}
