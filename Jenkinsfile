def runOnAgent(String command) {
    if (isUnix()) {
        sh command
    } else {
        bat command
    }
}

pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Environment') {
            steps {
                script {
                    runOnAgent('node --version')
                    runOnAgent('npm --version')
                }
            }
        }

        stage('Install') {
            steps {
                script {
                    runOnAgent('npm ci')
                }
            }
        }

        stage('Quality checks') {
            steps {
                script {
                    runOnAgent('npm run lint')
                    runOnAgent('npm run typecheck')
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    runOnAgent('npm test')
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    runOnAgent('npm run build')
                }
            }
        }
    }

    post {
        success {
            echo 'GitHub checkout, validation, tests, and production build completed successfully.'
        }
        failure {
            echo 'The Jenkins build failed. Review the stage logs above for the failing command.'
        }
    }
}
