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
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDS) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to Dev') {
            when {
                branch 'develop'
            }
            steps {
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace dev'
            }
        }

        stage('Deploy to QA') {
            when {
                branch 'qa'
            }
            steps {
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace qa'
            }
        }

        stage('Deploy to Staging') {
            when {
                branch 'staging'
            }
            steps {
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace staging'
            }
        }

        stage('Deploy to Prod (Manual)') {
            when {
                branch 'master'
            }
            steps {
                input message: 'Déployer en production ?'
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace prod'
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline terminé avec succès sur la branche ${env.BRANCH_NAME}"
        }
        failure {
            echo "❌ Échec du pipeline sur ${env.BRANCH_NAME}"
        }
    }
}
