pipeline {
    agent any
    environment {
        AZURE_CREDENTIALS = credentials('AZURE_CREDENTIALS_BDOEPFNE')
    }

    stages {
        stage('compile') {
            steps {
                withMaven(maven: '3.5.2', jdk: '1.8') {
                    sh "mvn clean compile"
                }
            }
        }

        stage('test') {
            steps {
                withMaven(maven: '3.5.2', jdk: '1.8') {
                    sh "mvn test"
                }
            }
        }
        stage('package') {
            steps {
                withMaven(maven: '3.5.2', jdk: '1.8') {
                    sh "mvn package"
                }
            }
        }
        stage('bake azure image') {
            environment {
                PACKER_HOME = tool name: 'packer-1.1.3', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation'
                PACKER_SUBSCRIPTION_ID = "fcc1ad01-b8a5-471c-812d-4a42ff3d6074"
                PACKER_LOCATION = "westeurope"
                PACKER_TENANT_ID = "787717a7-1bf4-4466-8e52-8ef7780c6c42"
                PACKER_OBJECT_ID = "56e89fa0-e748-49f4-9ff0-0d8b9e3d4057"
            }
            steps {
                ansiColor('xterm') {
                    sh 'PACKER_CLIENT_ID=${AZURE_CREDENTIALS_USR} PACKER_CLIENT_SECRET=${AZURE_CREDENTIALS_PSW} ${PACKER_HOME}/packer build packer/sample-app-server.json'
                }
            }
        }
    }
}
