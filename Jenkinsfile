pipeline{
    agent any
    stages{
        stage("Install Dependencies"){
            steps{
                sh '''
                    apt update
                    apt install -y docker.io sudo
                '''
            }
        }
         stage('Start Docker Daemon') {
            steps {
                sh '''
                    if ! pgrep dockerd > /dev/null; then
                        echo "Starting Docker daemon..."
                        nohup dockerd > /tmp/dockerd.log 2>&1 &
                        sleep 10
                    else
                        echo "Docker daemon is already running"
                    fi
                '''
            }
        }

        stage("Check Docker Version"){
            steps{
                sh 'docker --version'
            }
        }

        stage("Build Docker Image"){
            steps{
                sh 'docker build -t vishal:t1 .'
            }
        }

        stage('Login into Docker Hub'){
            environment{
                DOCKER_CRUDENTIALS = crundentials('dockerhub-creds')
            }
            steps{
                sh 'echo $DOCKER_CRUNDENTIALS_PSW | docker login -u $DOCKER_CRUDENTIALS_USR --password-stdin'
            }
         }

        stage{
            steps{
                script{
                    def imageTag = "v${env.BUILD_NUMBER}"
                    def fullImage ="${DOCKER_IMAGE}:${imageTag}"
                    sh """
                        docker tag vishal:t1 ${fullImage}
                        docker push ${fullImage}
                        docker tag ${fullImage} ${DOCKER_IMAGE}:latest
                        docker push ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
    }
}