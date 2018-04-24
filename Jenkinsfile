pipeline {
    agent any
    environment {
        AZURE_CREDENTIALS = credentials('AZURE_CREDENTIALS_BDOEPFNE')
        AZURE_SUBSCRIPTION_ID = "fcc1ad01-b8a5-471c-812d-4a42ff3d6074"
        AZURE_LOCATION = "westeurope"
        AZURE_TENANT_ID = "787717a7-1bf4-4466-8e52-8ef7780c6c42"
        AZURE_OBJECT_ID = "56e89fa0-e748-49f4-9ff0-0d8b9e3d4057"
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
        stage('bake azure image (packer build)') {
            environment {
                PACKER_HOME = tool name: 'packer-1.1.3', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation'
                PACKER_SUBSCRIPTION_ID = "${AZURE_SUBSCRIPTION_ID}"
                PACKER_LOCATION = "${AZURE_LOCATION}"
                PACKER_TENANT_ID = "${AZURE_TENANT_ID}"
                PACKER_OBJECT_ID = "${AZURE_OBJECT_ID}"
                PACKER_CLIENT_ID = "${AZURE_CREDENTIALS_USR}"
                PACKER_CLIENT_SECRET = "${AZURE_CREDENTIALS_PSW}"
            }
            steps {
                ansiColor('xterm') {
                    sh '${PACKER_HOME}/packer validate packer/sample-app-server.json'
                    sh '${PACKER_HOME}/packer build packer/sample-app-server.json'
                }
            }
        }
        stage('terraform apply') {
            environment {
                TERRAFORM_HOME = tool name: 'terraform-0.11.3', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
                ARM_SUBSCRIPTION_ID = "${AZURE_SUBSCRIPTION_ID}"
                ARM_TENANT_ID = "${AZURE_TENANT_ID}"
                ARM_CLIENT_ID = "${AZURE_CREDENTIALS_USR}"
                ARM_CLIENT_SECRET = "${AZURE_CREDENTIALS_PSW}"
                ARM_ENVIRONMENT="public"
            }
            steps {
                ansiColor('xterm') {
                    sh 'cd terraform && ${TERRAFORM_HOME}/terraform init'
                    sh 'cd terraform && ${TERRAFORM_HOME}/terraform plan -out plan.out'
                    sh 'cd terraform && ${TERRAFORM_HOME}/terraform apply -auto-approve plan.out'
                }
            }
        }
    }
}
