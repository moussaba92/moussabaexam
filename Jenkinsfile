pipeline {
    agent any

    environment {
        DOCKER_CREDS = credentials('dockerhub-creds')
        IMAGE_NAME = "moussaba78/app-moussaba-exam"
        DOCKER_TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                cleanWs() //  Nettoie le workspace Jenkins
                checkout scm
                sh 'ls -la' //  Affiche les fichiers clonés (debug)
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build("${IMAGE_NAME}:${DOCKER_TAG}")
                    echo "🛠️ Image construite : ${IMAGE_NAME}:${DOCKER_TAG}"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDS) {
                        def dockerImage = docker.image("${IMAGE_NAME}:${DOCKER_TAG}")
                        dockerImage.push()
                        echo " Image poussée sur DockerHub"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    def helmNamespace = env.BRANCH_NAME
                    sh """
                        helm upgrade --install app-moussaba-exam ./helm-chart \
                          --namespace ${helmNamespace} \
                          --create-namespace \
                          --set image.repository=${IMAGE_NAME} \
                          --set image.tag=${DOCKER_TAG} \
                          --set service.type=NodePort \
                          --set service.nodePort=30080
                    """
                }
            }
        }

        stage('Manual Approval for Prod') {
            when {
                branch 'master'
            }
            steps {
                input message: 'Confirmer le déploiement en production ?'
            }
        }
    }

    post {
        success {
            echo " Pipeline réussi sur ${env.BRANCH_NAME}"
        }
        failure {
            echo " Pipeline échoué sur ${env.BRANCH_NAME}"
        }
    }
}
