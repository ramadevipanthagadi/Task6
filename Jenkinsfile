pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-id')
        DOCKER_IMAGE = "sunithriyansh/rose:latest"
        EMAIL = "203b1a0565suni@gmail.com"
    }

    stages {

        stage('Checkout') {
            steps {
                script {
                    try {
                        git branch: 'main', url: 'https://github.com/ramadevipanthagadi/task6.git'
                        mail to: "${EMAIL}",
                             subject: "✅ Checkout Success",
                             body: "Code checkout completed successfully."
                    } catch (Exception e) {
                        mail to: "${EMAIL}",
                             subject: "❌ Checkout Failed",
                             body: "Checkout stage failed."
                        error "Checkout failed"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        sh 'docker build -t $DOCKER_IMAGE .'
                        mail to: "${EMAIL}",
                             subject: "✅ Docker Build Success",
                             body: "Docker image built successfully."
                    } catch (Exception e) {
                        mail to: "${EMAIL}",
                             subject: "❌ Docker Build Failed",
                             body: "Docker build failed."
                        error "Docker build failed"
                    }
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    try {
                        sh '''
                        echo "$DOCKERHUB_CREDENTIALS_PSW" | docker login \
                        -u "$DOCKERHUB_CREDENTIALS_USR" --password-stdin
                        '''
                        mail to: "${EMAIL}",
                             subject: "✅ Docker Login Success",
                             body: "Logged into DockerHub successfully."
                    } catch (Exception e) {
                        mail to: "${EMAIL}",
                             subject: "❌ Docker Login Failed",
                             body: "Docker login failed."
                        error "Docker login failed"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    try {
                        sh 'docker push $DOCKER_IMAGE'
                        mail to: "${EMAIL}",
                             subject: "✅ Docker Push Success",
                             body: "Docker image pushed successfully."
                    } catch (Exception e) {
                        mail to: "${EMAIL}",
                             subject: "❌ Docker Push Failed",
                             body: "Docker push failed."
                        error "Docker push failed"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    try {
                        sh '''
                        echo "Current directory:"
                        pwd
                        echo "Files in workspace:"
                        ls -R
                        kubectl apply -f k8s/deployment.yml --validate=false
                        '''
                        mail to: "${EMAIL}",
                             subject: "✅ Deployment Success",
                             body: "Application deployed successfully."
                    } catch (Exception e) {
                        mail to: "${EMAIL}",
                             subject: "❌ Deployment Failed",
                             body: "Deployment failed. Check cluster connection."
                        error "Deployment failed"
                    }
                }
            }
        }
    }

    post {
        success {
            mail to: "${EMAIL}",
                 subject: "🎉 Pipeline Success",
                 body: "All stages completed successfully."
        }

        failure {
            mail to: "${EMAIL}",
                 subject: "🚨 Pipeline Failed",
                 body: "Pipeline execution failed. Check Jenkins logs."
        }

        always {
            sh 'docker logout || true'
        }
    }
}
