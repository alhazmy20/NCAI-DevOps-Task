pipeline{
    agent any
    environment {
        repo = 'alhazmy20/NCAI-DevOps-Task'
    }
    stages{
        stage('Cloning'){
            steps{
                checkout scm
            }
        }
        stage('Building Frontend'){
            steps{
                docker.build("${repo}/frontend")
                sh "docker images"
            }
        }
    }
}