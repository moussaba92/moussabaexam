pipeline {
    agent any

    environment {
        IMAGE_NAME = "moussaba78/app-moussaba-exam"
        DOCKERHUB_TOKEN = credentials('moussaba78') // 
    }

    stages {
        stage('Checkout') {
            steps {
                cleanWs() // 🔄 Nettoyage du workspace
                checkout scm
                sh 'ls -la' // 📁 Debug : vérifier les fichiers clonés
            }
        }

        stage('Docker Login') {
            steps {
                sh 'echo "$DOCKERHUB_TOKEN" | docker login -u "$NOM" --password-stdin'
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
            steps {
                script {
                    dockerImage.push()
                    dockerImage.push('latest') // (optionnel)
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
