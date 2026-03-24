pipeline {
    agent any

    tools {
        maven 'mymave'
    }

    environment {
        DOCKER_USER = 'sunithriyansh'
        DOCKER_PASS = 'Sunitha@565'
        IMAGE_NAME  = 'rose'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/ramadevipanthagadi/hotstar_project.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t rose .'
            }
        }

        stage('Docker Run') {
            steps {
                sh 'docker rm -f cont1 || true'
                sh 'docker run -d --name cont1 -p 8010:80 rose'
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                sh 'docker tag imag1:latest $DOCKER_USER/$IMAGE_NAME:latest'
                sh 'docker push $DOCKER_USER/$IMAGE_NAME:latest'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yml'
                sh 'kubectl apply -f k8s/service.yml'
                sh 'kubectl apply -f k8s/ingress.yml'
            }
        }

    }
