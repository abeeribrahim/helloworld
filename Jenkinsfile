pipeline {
  environment {
    IMAGE_NAME = 'abeeralhussaini20/helloworld'
  }

  agent any

  stages {
     stage('Lint HTML') {
      steps {
        sh 'make'
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
    // stage('Test') {
    //   steps {
    //     echo 'TODO: add tests'
    //   }
    // }
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
    // stage('Staging Deployment') {
    //   when {
    //     expression { env.BRANCH_NAME == 'master' }
    //   }

    //   environment {
    //     RELEASE_NAME = 'helloworld-staging'
    //     SERVER_HOST = 'staging.helloworld.k8s.prydoni.us'
    //   }

    //   steps {
    //     sh '''
    //       . ./helm/helm-init.sh
    //       helm upgrade --install --namespace staging $RELEASE_NAME ./helm/helloworld --set image.tag=$BUILD_ID,ingress.host=$SERVER_HOST
    //     '''
    //   }
    // }
    // stage('Deploy to Production?') {
    //   when {
    //     expression { env.BRANCH_NAME == 'master' }
    //   }

    //   steps {
    //     // Prevent any older builds from deploying to production
    //     milestone(1)
    //     input 'Deploy to Production?'
    //     milestone(2)
    //   }
    // }
    // stage('Production Deployment') {
    //   when {
    //     expression { env.BRANCH_NAME == 'master' }
    //   }

    //   environment {
    //     RELEASE_NAME = 'helloworld-production'
    //     SERVER_HOST = 'helloworld.k8s.prydoni.us'
    //   }

    //   steps {
    //     sh '''
    //       . ./helm/helm-init.sh
    //       helm upgrade --install --namespace production $RELEASE_NAME ./helm/helloworld --set image.tag=$BUILD_ID,ingress.host=$SERVER_HOST
    //     '''
    //   }
    // }
  }
}
