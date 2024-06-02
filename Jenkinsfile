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
        stage("VERIFY TERRAFORM VERSION"){
            steps{
                echo "veifying terraform version"
                sh 'terraform --version'
            }
        }
        stage("INITIALIZE TERRAFORM"){
            steps{
                echo "initializing terraform"
                sh 'terraform init'
            }
        }
        stage("VALIDATING CONFIGURATION"){
            steps{
                echo "validating terraform configuration"
                sh 'terraform validate'
            }
        }
        stage("PLANNING CONFIGURATION"){
            steps{
                echo "planning terraform configuration"
                sh 'terraform plan'
            }
        }
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
        stage("TERRAFORM APPLY"){
            steps{
                echo "applying configuration"
                sh 'terraform destroy -auto-approve'
            }
        }
    }
    post {
        always {
            echo 'pipeline was successful'
        }
    }
}
