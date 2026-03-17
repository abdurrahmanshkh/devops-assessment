pipeline {
    agent any

    // Inject AWS credentials securely from Jenkins
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Infrastructure Security Scan') {
            steps {
                script {
                    echo "Running Trivy vulnerability scanner on patched Terraform configuration..."
                    sh 'trivy config --exit-code 1 --severity HIGH,CRITICAL ./terraform'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    echo "Initializing and planning Terraform deployment..."
                    // -chdir tells terraform to run inside the terraform folder
                    sh 'terraform -chdir=terraform init'
                    sh 'terraform -chdir=terraform plan'
                }
            }
        }
    }
    
    post {
        failure {
            echo "PIPELINE FAILED: Check logs for details."
        }
        success {
            echo "SUCCESS: Security scan passed and Terraform plan generated successfully!"
        }
    }
}