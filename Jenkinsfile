pipeline{
    agent any
    tools {
        terraform 'Terraform'
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages{
        stage("GIT CHECKOUT"){
            steps{
                echo "pulling code from codebase"
                git branch: 'main', changelog: false, url: 'https://github.com/HILL-TOPCONSULTANCY/terraform-workshop.git'
                sh 'ls'
            }
        }
    }
    stages{
        stage("VERIFY TERRAFORM VERSION"){
            steps{
                echo "veifying terraform version"
                sh 'terraform --version'
            }
        }
    }
    stages{
        stage("INITIALIZE TERRAFORM"){
            steps{
                echo "initializing terraform"
                sh 'terraform init'
            }
        }
    }
    stages{
        stage("VALIDATING CONFIGURATION"){
            steps{
                echo "validating terraform configuration"
                sh 'terraform validate'
            }
        }
    }
    stages{
        stage("PLANNING CONFIGURATION"){
            steps{
                echo "planning terraform configuration"
                sh 'terraform plan'
            }
        }
    }
    stages{
        stage("MANUAL VALIDATION"){
            steps{
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
    } 
    stages{
        stage("TERRAFORM APPLY"){
            steps{
                echo "applying configuration"
                sh 'terraform apply --autoapprove'
            }
        }
    }
    post {
        always {
            echo 'pipeline was successful'
        }
    }
}
