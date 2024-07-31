pipeline {
    agent any
    environment {
        frontendImage = 'nginx-frontend'
        backendImage = 'go-backend'
        scannerImage = 'aquasec/trivy:latest'
    }
    stages {
        stage('Building Frontend') {
            steps {
                script {
                    docker.build(env.frontendImage, "./frontend")
                }
            }
        }
        stage('Building Backend') {
            steps {
                script {
                    docker.build(env.backendImage, "./backend")
                }
            }
        }
        stage('Scanning Backend') {
            steps {
                script {
                    def scanner = docker.image(env.scannerImage)
                    scanner.inside {
                      //  sh "trivy --exit-code 1 --severity HIGH,CRITICAL ${env.backendImage}"
                    }
                    scanner.remove()
                }
            }
        }
    }
}
