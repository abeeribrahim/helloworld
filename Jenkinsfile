pipeline {
  environment {
    IMAGE_NAME = 'abeeralhussaini20/helloworld:latest'
    dockerhubCredentials = 'dockerhub'
  }

  agent any

  stages {
     stage('Lint HTML') {
      steps {
        sh 'tidy -q -e *.html'
      }
    }
    stage('Build and Push to dockerhub') {
            steps {
                script {
                    dockerImage = docker.build(IMAGE_NAME)
                    docker.withRegistry('', dockerhubCredentials) {
                        dockerImage.push()
                    }
                }
            }
        }
//     stage('Build Docker Image') {
//    steps {
//     withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub']]){
//      sh '''
//       docker build -t $IMAGE_NAME:$BUILD_ID .
//      '''
//     }
//    }
//   }
    stage('Deployment stage') {
            steps{
                withAWS(region:'us-west-2',credentials:'aws-credentials')  {
                    sh "aws eks --region us-west-2 update-kubeconfig --name capstone"
                    sh 'kubectl apply -f ./deployment.yml'
                }
            }
        }

    stage('Create Staging service') {
            steps{
                withAWS(region:'us-west-2',credentials:'aws-credentials')  {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                        sh 'kubectl apply -f ./staging-service.json'
                        sh 'kubectl get pods'
                        sh 'kubectl describe service staginglb'
                    }
                }
            }
        }
  }
}