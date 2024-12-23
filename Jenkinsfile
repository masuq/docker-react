pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_MUHAMMAD')  // Replace with your Jenkins credential ID
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY_MUHAMMAD')  // Replace with your Jenkins credential ID
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t masuqur/docker-react -f Dockerfile.dev .'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh 'docker run masuqur/docker-react npm run test -- --coverage'
                }
            }
        }

        stage('Deploy to Elastic Beanstalk') {
            steps {
                script {
                    withEnv(["AWS_REGION=us-east-1"]) {
                        sh '''
                        aws elasticbeanstalk create-application-version \
                            --application-name "docker-react" \
                            --version-label $BUILD_NUMBER \
                            --source-bundle S3Bucket="elasticbeanstalk-us-east-1-557690577839",S3Key="docker-react/$BUILD_NUMBER.zip"

                        aws elasticbeanstalk update-environment \
                            --application-name "docker-react" \
                            --environment-name "Docker-react-env" \
                            --version-label $BUILD_NUMBER
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                echo "Pipeline complete."
            }
        }
    }
}
