pipeline {
    agent any

    environment {
        DOCKER_USERNAME = "vishalmahawar5200"
        DOCKER_PASSWORD = "RJ09GC2017"
        DOCKER_IMAGE = "vishalmahawar5200/23april2025"
        DEPLOY_USER = "root"
        DEPLOY_HOST = "65.108.149.166"
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh '''
                    apt update
                    apt install -y docker.io sudo
                '''
            }
        }

        stage('Start Docker Daemon (if not running)') {
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

        stage('Verify Docker Version') {
            steps {
                sh 'docker --version'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t vishal:t1 .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    def imageTag = "v${env.BUILD_NUMBER}"
                    sh "docker tag vishal:t1 $DOCKER_IMAGE:${imageTag}"
                    sh "docker push $DOCKER_IMAGE:${imageTag}"
                }
            }
        }

        stage('Deploy to Server via Docker') {
            steps {
                sshagent (credentials: ['ID_RSA']) {
                    script {
                        def imageTag = "v${env.BUILD_NUMBER}"
                        sh """
                            ssh -o StrictHostKeyChecking=no $DEPLOY_USER@$DEPLOY_HOST \\
                            'docker pull $DOCKER_IMAGE:${imageTag} && \\
                            fuser -k 80/tcp || true && \\
                            docker stop mysite || true && \\
                            docker rm mysite || true && \\
                            docker run -d --name mysite -p 8084:80 $DOCKER_IMAGE:${imageTag}'
                        """
                    }
                }
            }
        }
    }
}
