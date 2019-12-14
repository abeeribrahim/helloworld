pipeline {
  environment {
    IMAGE_NAME = 'abeeralhussaini20/helloworld'
  }

  agent any

  stages {
     stage('Lint HTML') {
      steps {
        sh 'tidy -q -e *.html'
      }
    }
    stage('Build Docker Image') {
   steps {
    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'abalhussaini20', passwordVariable: 'Abeer@12345']]){
     sh '''
      docker build -t $IMAGE_NAME:$BUILD_ID .
     '''
    }
   }
  }
    stage('Image Release') {
      when {
        expression { env.BRANCH_NAME == 'master' }
      }

      steps {
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub',
          usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
          sh '''
            docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
            docker push $IMAGE_NAME:$BUILD_ID
          '''
        }
      }
    }
        stage('Set Kubectl Context to Cluster') {
            steps{
                withAWS(region:'us-west-2',credentials:'capstone')  {
                sh 'kubectl config use-context arn:aws:eks:us-west-2:532830860357:cluster/capstone'
                }
            }
        }
        stage('Create Staging Controller') {
            steps{
                withAWS(region:'us-west-2',credentials:'capstone')  {
                    sh 'kubectl apply -f ./staging-controller.json'

                }
            }
        }
        stage('Rollout Staging Changes') {
            steps{
                withAWS(region:'us-west-2',credentials:'capstone')  {
                    sh 'kubectl rolling-update staging --image=abeeralhussaini20/helloworld:latest'
                }
            }
        }
        stage('Create Staging service') {
            steps{
                withAWS(region:'us-west-2',credentials:'capstone')  {
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                        sh 'kubectl apply -f ./staging-service.json'
                        sh 'kubectl get pods'
                        sh 'kubectl describe service staginglb'
                    }
                }
            }
        }
        stage('Deploy to Production?') {
              when {
                expression { env.BRANCH_NAME != 'master' }
              }

              steps {
                // Prevent any older builds from deploying to production
                milestone(1)
                input 'Deploy to Production?'
                milestone(2)
              }
        }
  }
}