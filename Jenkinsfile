pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        withMaven(maven: '3.5.2', jdk: '1.8') {
          // test 2
          sh "mvn clean package"
        }
      }
    }
  }
}
