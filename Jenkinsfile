pipeline {
    agent any

    tools {
        terraform 'Terraform'
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'Cloning project codebase...'
                git branch: 'main', url: 'https://github.com/HILL-TOPCONSULTANCY/terraform-workshop'
                sh 'ls'
            }
        }

        stage('Verify Terraform Version') {
            steps {
                echo 'Verifying the Terraform version...'
                sh 'terraform --version'
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                echo 'Validating Terraform configuration...'
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                echo 'Planning Terraform deployment...'
                sh 'terraform plan'
            }
        }

        stage('Manual Approval') {
            steps {
                script {
                    def userInput = input(id: 'Proceed', message: 'Approve Terraform Apply?', parameters: [
                        [$class: 'TextParameterDefinition', defaultValue: 'Yes', description: 'Type Yes to approve', name: 'Approval']
                    ])
                    if (userInput != 'Yes') {
                        error "Pipeline aborted by user"
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Applying Terraform configuration...'
                sh 'terraform apply --auto-approve'
            }
        }

        stage('Manual Approval to Delete Resources') {
            steps {
                input 'Approval required to clean environment'
            }
        }

        stage('Terraform Destroy') {
            steps {
                echo 'Destroying Terraform-managed infrastructure...'
                sh 'terraform destroy --auto-approve'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
    }
}
