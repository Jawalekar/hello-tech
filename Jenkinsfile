pipeline {
    agent {
        label 'ubuntu'
    }

    environment {
        acr_server = credentials('acr_server') // Azure Container Registry server
        acr_username = credentials('acr_username') // ACR username
        acr_password = credentials('acr_password') // ACR password
    }

    stages {
        stage('Log in to ACR') {
            steps {
                script {
                    echo 'Logging in to Azure Container Registry...'
                    sh """
                    echo $acr_password | docker login $acr_server --username $acr_username --password-stdin
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh """
                    docker build -t $acr_server/hello-techie:latest .
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo 'Pushing Docker image to ACR...'
                    sh """
                    docker push $acr_server/hello-techie:latest
                    """
                }
            }
        }

        stage('Deploy to AKS using Helm') {
            steps {
                script {
                    echo 'Deploying to AKS using Helm...'
                    withKubeConfig([credentialsId: 'configfile']) {
                        sh """
                        helm upgrade --install hello-techie ./hello-techie --namespace jenkins --set image.repository=$acr_server/hello-techie,image.tag=latest
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                echo 'Cleaning up Docker resources...'
                sh 'docker system prune -af'
            }
        }

        success {
            echo 'Build, push, and deployment completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
