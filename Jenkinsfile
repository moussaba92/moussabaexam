pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = credentials('dockerhub-creds')
        IMAGE_NAME = 'moussaba78/app-moussaba-exam'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/moussaba92/moussabaexam.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to Dev') {
            when { branch 'develop' }
            steps {
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace dev'
            }
        }

        stage('Deploy to QA') {
            when { branch 'qa' }
            steps {
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace qa'
            }
        }

        stage('Deploy to Staging') {
            when { branch 'staging' }
            steps {
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace staging'
            }
        }

        stage('Manual Prod Deploy') {
            when { branch 'master' }
            steps {
                input "Déployer manuellement en production ?"
                sh 'helm upgrade --install app-moussaba-exam ./helm-chart --namespace prod'
            }
        }
    }
}
