pipeline {
    agent any

    tools {
        maven 'maven-3'
        jdk 'jdk17'
    }

    environment {
        SONARQUBE_ENV = 'sonarqube-local'
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
                SERVICES=(
                  spring-petclinic-config-server
                  spring-petclinic-discovery-server
                  spring-petclinic-api-gateway
                  spring-petclinic-customers-service
                  spring-petclinic-vets-service
                  spring-petclinic-visits-service
                  spring-petclinic-admin-server
                )

                for service in "${SERVICES[@]}"; do
                  echo "Building Docker image for $service"
                  cd $service
                  docker build -t athulraj9thd/$service:dev .
                  cd ..
                done
                '''
            }
        }
    }
}
