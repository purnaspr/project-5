pipeline{
    agent any

    stages{
        stage('clone code'){
            steps{
                echo 'clone the code'
                checkout scm
            }
        }
        stage('build the code'){
            steps{
                sh'''
                python3 -m venv venv
                . venv/bin/activate
                python -m pip install --upgrade pip
                pip install flask
                '''
            }
        }
        stage('scan the code'){
            steps{
                withSonarQubeEnv(installationName: 'SonarQube', credentialsId: 'SonarQube'){
                    script{
                    def scannerHome = tool 'sonar-scanner'
                    sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }
        stage ('Quality Gate'){
            steps{
                timeout(time: 5, unit: 'MINUTES'){
                waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('docker build image'){
            steps{
                sh'''
                docker build -t netflix .
                docker tag netflix purnaspr/netflix:1.0
                '''
            }
        }
        stage('push image on github'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'Docker', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh'''
                    docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                    docker push purnaspr/netflix:1.0
                    '''
}
            }
        }
    }
}
