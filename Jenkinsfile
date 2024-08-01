pipeline {
    agent any
    environment {
        FRONTEND_IMAGE_NAME = 'aalhazmi-frontend'
        BACKEND_IMAGE_NAME = 'aalhazmi-backend'
        SCANNER_IMAGE = 'aquasec/trivy:latest'
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
        // stage('Scanning Images') {
        //     steps {
        //         script {
        //             sh '''
        //             for image in $BACKEND_IMAGE_NAME $FRONTEND_IMAGE_NAME; 
        //                 do docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
        //                 $SCANNER_IMAGE image --exit-code 1 --severity HIGH,CRITICAL "$image";
        //             done
        //             '''
        //         }
        //     }
        // }
        stage('Pushing images to ACR') {
            steps {
                script {
                    docker.withRegistry('https://devncai.azurecr.io', 'AzureCredential') {
                        docker.image(env.BACKEND_IMAGE_NAME).push()
                        docker.image(env.FRONTEND_IMAGE_NAME).push()
                    }
                }
            }
        }
        stage('Cleaning') {
            steps {
                sh '''
                for image in $BACKEND_IMAGE_NAME $FRONTEND_IMAGE_NAME
                do docker rmi "$image";
                done;
                '''
            }
        }
    }
}
