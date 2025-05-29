pipeline {
    agent any

    environment {
        IMAGE_NAME = '1sharathchandra/project04'
        BASE_VERSION_STR = '1.0'
        DOCKERHUB_CRED = 'dockerhub'
        GIT_REPO_URL = 'https://github.com/Sharathchandra3/project04.git'
        GIT_BRANCH = 'main'
    }

    stages {
        stage('Set version tag') {
            steps {
                script {
                    env.VERSION_TAG = "v${BASE_VERSION_STR}-${env.BUILD_NUMBER}"
                    echo "VERSION_TAG set to: ${env.VERSION_TAG}"
                }
            }
        }

        stage('Checkout') {
            steps {
                git url: "${env.GIT_REPO_URL}", branch: "${env.GIT_BRANCH}"
            }
        }

        stage('Clean old images') {
            steps {
                sh 'docker images -q | xargs -r docker rmi -f || true'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def image = docker.build("${IMAGE_NAME}:${env.VERSION_TAG}")
                    sh "docker tag ${IMAGE_NAME}:${env.VERSION_TAG} ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: DOCKERHUB_CRED, variable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u 1sharathchandra --password-stdin'
                }
                sh """
                    docker push ${IMAGE_NAME}:${env.VERSION_TAG}
                    docker push ${IMAGE_NAME}:latest
                """
                sh 'docker images -q | xargs -r docker rmi -f || true'
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([
                    file(credentialsId: 'k8s', variable: 'KUBECONFIG_FILE')
                ]) {
                    sh '''
                        kubectl --kubeconfig=$KUBECONFIG_FILE apply -f deployment.yml
                        kubectl --kubeconfig=$KUBECONFIG_FILE rollout status deployment/project04-deployment --timeout=60s
                    '''
                }
            }
        }
    }
}
