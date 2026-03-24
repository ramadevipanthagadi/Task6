pipeline {
    agent any

    tools {
        maven 'mymave'   
         
    }

    environment {
        DOCKER_USER  = 'sunithriyansh'
        DOCKER_PASS  = credentials('dockerhub-id')  
        IMAGE_NAME   = 'rose'
        MAVEN_OPTS   = '-Dmaven.repo.local=$WORKSPACE/.m2/repository'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/ramadevipanthagadi/hotstar_project.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mkdir -p $WORKSPACE/.m2/repository'
                sh 'mvn clean package -Dmaven.repo.local=$WORKSPACE/.m2/repository'
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
                sh 'docker run -d --name cont1 -p 8000:8080 rose'
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                docker tag rose:latest $DOCKER_USER/$IMAGE_NAME:latest
                docker push $DOCKER_USER/$IMAGE_NAME:latest
                '''
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

    post {
        success {
            echo 'Pipeline Completed Successfully ✅'
        }
        failure {
            echo 'Pipeline Failed ❌'
        }
    }
}
