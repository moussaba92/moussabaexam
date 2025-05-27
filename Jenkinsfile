pipeline {
    agent any

    environment {
        DOCKER_CREDS = credentials('dockerhub-creds')
        IMAGE_NAME = "moussaba78/app-moussaba-exam"
        DOCKER_TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Debug Branch') {
            steps {
                echo "📌 Branche active : ${env.BRANCH_NAME}"
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${DOCKER_TAG}")
                    echo "✅ Image construite : ${IMAGE_NAME}:${DOCKER_TAG}"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDS) {
                        dockerImage.push()
                        dockerImage.push("latest")
                    }
                    echo "📦 Image poussée avec succès :"
                    echo "- ${IMAGE_NAME}:${DOCKER_TAG}"
                    echo "- ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy to Dev') {
            when {
                branch 'develop'
            }
            steps {
                echo "🚀 Déploiement dans namespace : dev"
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace dev'
            }
        }

        stage('Deploy to QA') {
            when {
                branch 'qa'
            }
            steps {
                echo "🚀 Déploiement dans namespace : qa"
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace qa'
            }
        }

        stage('Deploy to Staging') {
            when {
                branch 'staging'
            }
            steps {
                echo "🚀 Déploiement dans namespace : staging"
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace staging'
            }
        }

        stage('Deploy to Prod (Manual)') {
            when {
                branch 'master'
            }
            steps {
                input message: '✅ Déployer manuellement en production ?'
                echo "🚀 Déploiement dans namespace : prod"
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace prod'
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline terminé avec succès sur la branche ${env.BRANCH_NAME}"
        }
        failure {
            echo "❌ Échec du pipeline sur la branche ${env.BRANCH_NAME}"
        }
    }
}
