pipeline{
    agent any
    environment{
        frontendImage = 'nginx-frontend'
        backendImage = 'go-backend'
    }
    stages{
        stage('Building Frontend'){
            steps{
                script{
                  docker.build(env.frontendImage,"./frontend")
                }
            }
        }

           stage('Building Backend'){
            steps{
                script{
                  docker.build(env.frontendImage,"./backend")
                }
            }
        }
    }
}