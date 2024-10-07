pipeline {
  agent any

  environment {
    APP_NAME = 'my-react-app'
    DOCKER_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER}"
  }

  stages {
    stage('Build') {
      steps {
        script {
          // Build the Docker image using multi-stage Dockerfile
          sh 'docker build -t ${DOCKER_IMAGE} --target build .'

          // Run tests during the build stage
         // sh 'docker run --rm ${DOCKER_IMAGE} npm run test'  // stuck at testing 
        }
      }
    }

    stage('Deploy') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
          sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin ${DOCKER_REGISTRY}"
          sh 'docker push ${DOCKER_IMAGE}'
        }
      }
    }
  }

  post {
    always {
      sh 'docker logout'
      sh 'docker system prune -f'
    }
  }
}

// pipeline {
//   agent any
  
//   environment {
//     APP_NAME = 'my-react-app'
//     DOCKER_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER}"
//   }

//   stages {
//     stage('Build') {
//       steps {
//         script {
//           // Build the Docker image using multi-stage Dockerfile
//           sh 'docker build -t ${DOCKER_IMAGE} .'
//         }
//       }
//     }

//     stage('Test') {
//       steps {
//         // Run tests in a Node container before the actual build stage
//         sh 'docker run --rm ${DOCKER_IMAGE} npm run test'
//       }
//     }

//     stage('Deploy') {
//       steps {
//         withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
//           // Log into Docker Hub or private registry
//           sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin ${DOCKER_REGISTRY}"
          
//           // Push the Docker image to the registry
//           sh 'docker push ${DOCKER_IMAGE}'
//         }
//       }
//     }
//   }

//   post {
//     always {
//       // Clean up Docker after pipeline execution
//       sh 'docker logout'
//       sh 'docker system prune -f'
//     }
//   }
// }
