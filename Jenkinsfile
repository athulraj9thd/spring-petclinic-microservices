pipeline {
    agent any

    tools {
        maven 'maven-3'
        jdk 'jdk17'
    }

    environment {
        SONARQUBE_ENV = 'sonarqube-local'
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
        DOCKERHUB_USER = 'athulraj9thd'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh '''
                    mvn sonar:sonar \
                      -Dsonar.projectKey=petclinic-microservices \
                      -Dsonar.projectName=petclinic-microservices \
                      -Dsonar.java.binaries=.
                    '''
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                for service in \
                  spring-petclinic-config-server \
                  spring-petclinic-discovery-server \
                  spring-petclinic-api-gateway \
                  spring-petclinic-customers-service \
                  spring-petclinic-vets-service \
                  spring-petclinic-visits-service \
                  spring-petclinic-admin-server
                do
                  echo "Building Docker image for $service"
                  cd "$service"
                  docker build -t ${DOCKERHUB_USER}/$service:dev .
                  cd ..
                done
                '''
            }
        }

        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDENTIALS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                    for service in \
                      spring-petclinic-config-server \
                      spring-petclinic-discovery-server \
                      spring-petclinic-api-gateway \
                      spring-petclinic-customers-service \
                      spring-petclinic-vets-service \
                      spring-petclinic-visits-service \
                      spring-petclinic-admin-server
                    do
                      echo "Pushing Docker image for $service"
                      docker push ${DOCKERHUB_USER}/$service:dev
                    done

                    docker logout
                    '''
                }
            }
        }
    }
}
