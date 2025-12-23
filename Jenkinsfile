pipeline {
    agent any

    tools {
        maven 'maven-3'
        jdk 'jdk17'
    }

    environment {
        SONARQUBE_ENV = 'sonarqube-local'
        DOCKER_NAMESPACE = 'athul9thd'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Determine Environment') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        env.ENV = 'dev'
                        env.NAMESPACE = 'petclinic-dev'
                    } else if (env.BRANCH_NAME == 'uat') {
                        env.ENV = 'uat'
                        env.NAMESPACE = 'petclinic-uat'
                    } else if (env.BRANCH_NAME == 'main') {
                        env.ENV = 'prod'
                        env.NAMESPACE = 'petclinic-prod'
                    } else {
                        error "Unsupported branch: ${env.BRANCH_NAME}"
                    }
                }

                sh '''
                  echo "Branch      : $BRANCH_NAME"
                  echo "Environment : $ENV"
                  echo "Namespace   : $NAMESPACE"
                '''
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
                  SERVICES="
                  spring-petclinic-config-server
                  spring-petclinic-discovery-server
                  spring-petclinic-api-gateway
                  spring-petclinic-customers-service
                  spring-petclinic-vets-service
                  spring-petclinic-visits-service
                  spring-petclinic-admin-server
                  "

                  for service in $SERVICES; do
                    echo "Building image: $service"
                    cd $service
                    docker build -t ${DOCKER_NAMESPACE}/$service:${ENV} .
                    cd ..
                  done
                '''
            }
        }

        stage('Push Docker Images') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                      echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                      SERVICES="
                      spring-petclinic-config-server
                      spring-petclinic-discovery-server
                      spring-petclinic-api-gateway
                      spring-petclinic-customers-service
                      spring-petclinic-vets-service
                      spring-petclinic-visits-service
                      spring-petclinic-admin-server
                      "

                      for service in $SERVICES; do
                        echo "Pushing image: $service:${ENV}"
                        docker push ${DOCKER_NAMESPACE}/$service:${ENV}
                      done
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                  MANIFEST_DIR="k8s/${ENV}"

                  if [ ! -d "$MANIFEST_DIR" ]; then
                    echo "ERROR: $MANIFEST_DIR does not exist"
                    exit 1
                  fi

                  echo "Deploying manifests from $MANIFEST_DIR to namespace $NAMESPACE"

                  kubectl apply -f $MANIFEST_DIR/namespace.yaml || true
                  kubectl apply -f $MANIFEST_DIR
                '''
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD pipeline completed successfully for ${ENV}"
        }
        failure {
            echo "❌ CI/CD pipeline failed for ${ENV}"
        }
    }
}
