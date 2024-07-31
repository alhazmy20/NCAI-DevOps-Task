pipeline {
    agent any
    environment {
        FRONTEND_IMAGE_NAME = 'nginx-frontend'
        BACKEND_IMAGE_NAME = 'go-backend'
        SCANNER_IMAGE = 'aquasec/trivy:latest'
        // Azure Credentials
        AZURE_SUBSCRIPTION_ID = credentials('azure_subscription_id')
        AZURE_TENANT_ID = credentials('azure_tenant_id')
        CONTAINER_REGISTRY = 'devncai'
        RESOURCE_GROUP = 'NE-Dev-Apps'
        REPO = 'aalhazmi-repo'      
    }
    stages {
        stage('Building Frontend') {
            steps {
                script {
                    docker.build(env.FRONTEND_IMAGE_NAME, "./frontend")
                }
            }
        }
        stage('Building Backend') {
            steps {
                script {
                    docker.build(env.BACKEND_IMAGE_NAME, "./backend")
                }
            }
        }
        // stage('Scanning Backend') {
        //     steps {
        //         script {
        //             sh """
        //             docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
        //                 ${env.SCANNER_IMAGE} image --exit-code 1 --severity HIGH,CRITICAL ${env.BACKEND_IMAGE_NAME}
        //             """

        //         }
        //             sh 'docker rmi $SCANNER_IMAGE'
        //     }
        // }
        stage('Pushing image to ACR'){
            steps {
                withCredentials([usernamePassword(credentialsId: 'AzureCredential')]) {
                    // sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                    script {
                        docker.withRegistry('https://devncai.azurecr.io','AzureCredential'){
                            docker.image('devncai.azurecr.io/aalhazmi-go-backend').push()
                        }
                    }
                 }
            }
        }
        // stage('Cleaning'){
        //     steps{

        //     }
        // }
    }
}
