pipeline{
    agent any
    triggers {
     githubPush()
  }
    stages{
        stage('Building Frontend'){
            steps{
                sh "ls"
                script{
                  docker.build("nginx-frontend","./frontend")
                }
                sh "docker images"
            }
        }

           stage('Building Backend'){
            steps{
                script{
                  docker.build("go-backend","./backend")
                }
            }
        }
    }
}