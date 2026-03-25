pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-id')
        DOCKER_IMAGE = "sunithriyansh/rose:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ramadevipanthagadi/task6.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                sh '''
                echo "$DOCKERHUB_CREDENTIALS_PSW" | docker login \
                -u "$DOCKERHUB_CREDENTIALS_USR" --password-stdin
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                echo "Current directory:"
                pwd
                echo "Files in workspace:"
                ls -R
                kubectl apply -f k8s/
                '''
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
    }
}
