pipeline {
    agent any

    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'uat', 'prod'],
            description: 'Target environment'
        )
    }

    environment {
        DOCKER_REGISTRY = 'athul9thd'
        MAVEN_OPTS = '-Dmaven.test.skip=true'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Tools') {
            steps {
                sh '''
                  java -version
                  mvn -version
                  docker --version
                  kubectl version --client
                '''
            }
        }

        stage('Maven Build') {
            steps {
                sh '''
                  mvn clean package -DskipTests
                '''
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('sonarqube-local') {
                    sh '''
                      mvn sonar:sonar
                    '''
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                  docker build -t ${DOCKER_REGISTRY}/spring-petclinic-config-server:${ENV} spring-petclinic-config-server
                  docker build -t ${DOCKER_REGISTRY}/spring-petclinic-discovery-server:${ENV} spring-petclinic-discovery-server
                  docker build -t ${DOCKER_REGISTRY}/spring-petclinic-api-gateway:${ENV} spring-petclinic-api-gateway
                  docker build -t ${DOCKER_REGISTRY}/spring-petclinic-customers-service:${ENV} spring-petclinic-customers-service
                  docker build -t ${DOCKER_REGISTRY}/spring-petclinic-vets-service:${ENV} spring-petclinic-vets-service
                  docker build -t ${DOCKER_REGISTRY}/spring-petclinic-visits-service:${ENV} spring-petclinic-visits-service
                '''
            }
        }

        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                      echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                      docker push ${DOCKER_REGISTRY}/spring-petclinic-config-server:${ENV}
                      docker push ${DOCKER_REGISTRY}/spring-petclinic-discovery-server:${ENV}
                      docker push ${DOCKER_REGISTRY}/spring-petclinic-api-gateway:${ENV}
                      docker push ${DOCKER_REGISTRY}/spring-petclinic-customers-service:${ENV}
                      docker push ${DOCKER_REGISTRY}/spring-petclinic-vets-service:${ENV}
                      docker push ${DOCKER_REGISTRY}/spring-petclinic-visits-service:${ENV}
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                  kubectl apply -f k8s/${ENV}/namespace.yaml
                  kubectl apply -f k8s/${ENV}
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment to ${params.ENV} completed successfully"
        }
        failure {
            echo "❌ Deployment to ${params.ENV} failed"
        }
    }
}
