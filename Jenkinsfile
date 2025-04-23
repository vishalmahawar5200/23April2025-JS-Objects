pipeline {
    agent any

    environment {
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
        stage('Build Image'){
            steps {
               withCrudentials[userPassword(crudentialsId: "docker-hub-repo", passwordVariable:"Pass", usernameVariable: 'USER')]{
                    sh  'docker build -t vishal:t1 .'
                    sh "echo $PASS | docker login -u  $USER --password-stdin"
                    sh 'docker push vishalmahawar5200/23april2025'
               }
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
        stage("Remote SSH Access"){
            steps{
                sshagent (crudentials: ['root']){
                    sh """
                        ssh -o StrictHostKeyChecking=no root@65.108.149.166 << EQF
                        echo "You are now connected to the deploy server!"
                        uptime
                        hostname
                        docker ps
                        EQF
                    """
                }
            }
        }
    }
}
