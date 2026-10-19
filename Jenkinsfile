
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'bussiness-app:1.0'
        CLUSTER_NAME = 'project'
        DEPLOYMENT_NAME = 'java'
        CONTAINER_NAME = 'java'
        NAMESPACE = 'default'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Check Tools') {
            steps {
                sh '''
                    java -version
                    mvn -version
                    docker --version
                    kubectl version --client
                    kind version
                '''
            }
        }

        stage('Build and Test') {
            steps {
                sh 'mvn clean verify'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME} .
                '''
            }
        }

        stage('Load Image into kind') {
            steps {
                sh '''
                    kind load docker-image ${IMAGE_NAME} \
                      --name ${CLUSTER_NAME}
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f k8s/
                    kubectl rollout status deployment/${DEPLOYMENT_NAME} \
                      -n ${NAMESPACE} --timeout=180s
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    kubectl get pods -n ${NAMESPACE}
                    kubectl get services -n ${NAMESPACE}
                '''
            }
        }
    }

    post {
        success {
            echo 'Build and deployment completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the stage logs above.'
        }
    }
}

