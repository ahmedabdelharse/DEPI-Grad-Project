pipeline {
  agent any

  // parameters {
  //   string(name: 'DOCKER_REGISTRY', defaultValue: 'docker.io', description: 'Docker registry to push to')
  //   string(name: 'DOCKER_REGISTRY_CREDS', defaultValue: 'docker-registry-credentials', description: 'Docker registry credentials')
  // }

  environment {
    APP_NAME = 'my-react-app'
    DOCKER_IMAGE_LATEST = "${DOCKER_REGISTRY}/${APP_NAME}:latest"
    DOCKER_IMAGE_TAGGED = "${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER}"
  }

  stages {
    stage('Build') {
      steps {
        timeout(time: 20, unit: 'MINUTES') {
          script {
            // Build the Docker image using multi-stage Dockerfile with caching
            sh 'docker build --cache-from ${DOCKER_IMAGE_LATEST} -t ${DOCKER_IMAGE_LATEST} -t ${DOCKER_IMAGE_TAGGED} .'
          }
        }
      }
    }

    stage('Test') {
      steps {
        script {
          // Run tests in the build stage of the Dockerfile, where npm is available
          sh 'docker run --rm --entrypoint "" ${DOCKER_IMAGE_LATEST} npm run test'
        }
      }
    }

    stage('Deploy') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
          script {
            // Login to Docker
            sh '''
                echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin ${DOCKER_REGISTRY}
            '''

            // Retry push in case of network issues
            retry(3) {
              sh 'docker push ${DOCKER_IMAGE_LATEST}'
              sh 'docker push ${DOCKER_IMAGE_TAGGED}'
            }
          }
        }
      }
    }
  }

  post {
    always {
      script {
        // Clean up Docker images locally to free up space
        sh 'docker rmi ${DOCKER_IMAGE_LATEST} ${DOCKER_IMAGE_TAGGED} || true' // ignore error if image is not found
        sh 'docker system prune -f'
        sh 'docker logout'
      }
    }
  }
}




// pipeline {
//   agent any

//   environment {
//     APP_NAME = 'my-react-app'
//     DOCKER_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}:latest"
//     // DOCKER_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER}"
//     // DOCKER_IMAGE = "ahmedabdelhares/${APP_NAME}:${BUILD_NUMBER}"
//     // docker push ahmedabdelhares/my-react-app:tagname

//   }

//   stages {
//     stage('Build') {
//       steps {
//         script {
//           // Build the Docker image using multi-stage Dockerfile
//           sh 'docker build -t ${DOCKER_IMAGE} .'

//           // Run tests during the build stage
//          // sh 'docker run --rm ${DOCKER_IMAGE} npm run test'  // stuck at testing 
//         }
//       }
//     }

//     stage('Deploy') {
//       steps {
//         withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
//             sh '''
//                 echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin docker.io
//             '''
//             sh 'docker push ${DOCKER_IMAGE}'
//             }
//         //     sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin ${DOCKER_REGISTRY}"
//         //   sh 'docker push ${DOCKER_IMAGE}'
//       }
//     }
//   }

//   post {
//     always {
//       sh 'docker logout'
//       sh 'docker system prune -f'
//     }
//   }
// }

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
