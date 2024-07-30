pipeline{
    agent any
    environment {
        repo = 'alhazmy20/NCAI-DevOps-Task'
        tag = 'latest'
    }
    stages{
        stage('Cloning'){
            steps{
                checkout scm
            }
        }
        stage('Building Frontend'){
            steps{
                sh "ls"
                script{
                  docker.build("nginx-frontend","./frontend")
                }
                sh "docker images"
            }
        }
    }
}