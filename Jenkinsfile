pipeline {
  agent {
    kubernetes {
      label 'jenkins-slave'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: dind
    image: brainupgrade/docker:20-dind
    env:
    - name: DOCKER_TLS_CERTDIR
      value: ''
    securityContext:
      privileged: true
  - name: docker
    env:
    - name: DOCKER_HOST
      value: 127.0.0.1
    image: docker
    command:
    - cat
    tty: true
    startupProbe:
      tcpSocket:
        port: 2375
      periodSeconds: 10
      successThreshold: 1
      failureThreshold: 10  
  - name: tools
    image: argoproj/argo-cd-ci-builder
    command:
    - cat
    tty: true
"""
    }
  }
  stages {

    stage('Build') {
      environment {
        DOCKERHUB_CREDS = credentials('dockerhub')
      }
      steps {
        container('docker') {
          sh "docker build -t brainupgrade/hello:${env.GIT_COMMIT} ."
          sh "docker login --username $DOCKERHUB_CREDS_USR --password $DOCKERHUB_CREDS_PSW"
          sh "docker push brainupgrade/hello:${env.GIT_COMMIT}"
        }
      }
    }

    stage('Deploy E2E') {
      environment {
        GIT_CREDS = credentials('git')
      }
      steps {
        container('tools') {
          sh "git clone https://$GIT_CREDS_USR:$GIT_CREDS_PSW@github.com/brainupgrade-in/gitops-k8s-apps.git"
          sh "git config --global user.email 'ci@ci.com'"

          dir("hello") {
            sh "cd ./e2e && kustomize edit set image brainupgrade/hello:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push || echo 'no changes'"
          }
        }
      }
    }
    stage('Deploy to UAT') {
      steps {
        input message:'Approve deployment to UAT?'
        container('tools') {
          dir("hello") {
            sh "cd ./uat && kustomize edit set image brainupgrade/hello:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push || echo 'no changes'"
          }
        }
      }
    }

    stage('Deploy to Prod') {
      steps {
        input message:'Approve deployment to PROD?'
        container('tools') {
          dir("hello") {
            sh "cd ./prod && kustomize edit set image brainupgrade/hello:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push || echo 'no changes'"
          }
        }
      }
    }
  }
}
