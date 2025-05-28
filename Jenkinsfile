pipeline {
    agent any

    environment {
        IMAGE_NAME = "moussaba78/app-moussaba-exam"
        DOCKER_TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                cleanWs() // 🔥 Nettoyage du workspace Jenkins
                checkout scm
                sh 'ls -la' // 🧪 Debug : voir les fichiers clonés
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${DOCKER_TAG}")
                    echo "🛠️ Image construite : ${IMAGE_NAME}:${DOCKER_TAG}"
                }
            }
        }

        stage('Push to DockerHub') {
            environment {
                DOCKERHUB_CREDS = credentials('moussaba78')
            }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDS) {
                        dockerImage.push()
                        dockerImage.push('latest') // (optionnel)
                    }
                    echo "🚀 Image poussée : ${IMAGE_NAME}:${DOCKER_TAG}"
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
                    echo "📦 Déployé dans le namespace ${helmNamespace}"
                }
            }
        }

        stage('Manual Approval for Prod') {
            when {
                branch 'master'
            }
            steps {
                input message: '✅ Confirmer le déploiement en production ?'
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline réussi sur ${env.BRANCH_NAME}"
        }
        failure {
            echo "❌ Pipeline échoué sur ${env.BRANCH_NAME}"
        }
    }
}
