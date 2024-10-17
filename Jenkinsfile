pipeline {
    agent any

    environment {
        // AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')  // Reference the credential ID from Jenkins
        // AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')  // Reference the credential ID from Jenkins
        APP_NAME = 'my-react-app'
        DOCKER_IMAGE_LATEST = "${DOCKER_REGISTRY}/${APP_NAME}:latest"
        DOCKER_PLATFORM = "docker.io"
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        // stage('Terraform Init') {
        //     steps {
        //         dir('terraform-ec2/') {  // Adjust the path as necessary
        //         sh 'terraform init'
        //         }
        //     }
        // }

        // stage('Terraform apply') {
        //     steps {
        //         dir('terraform-ec2/') {  // Adjust the path as necessary
        //         // sh 'terraform apply -auto-approve'
        //         // }
        //         withCredentials([file(credentialsId: 'secrets.tfvars', variable: 'TF_VARS_FILE')]) {
        //                 sh 'terraform apply -auto-approve -var-file=${TF_VARS_FILE}'
        //             }
        //         }
        //     }
        // }

        // stage('Terraform Destroy') {
        //     steps {
        //         // Use AWS Access Key ID and Secret Access Key
        //         withCredentials([usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
        //             dir('terraform-ec2/') {  // Adjust the path as necessary
        //                 withCredentials([file(credentialsId: 'secrets.tfvars', variable: 'TF_VARS_FILE')]) {
        //                     // Run the Terraform apply command
        //                     sh 'terraform destroy -auto-approve -var-file=${TF_VARS_FILE}'
        //                 }
        //             }
        //         }
        //     }
        // }

        stage('Build') { //need cache to work to save up resources
            steps {
                timeout(time: 20, unit: 'MINUTES') {
                    script {
                        sh "docker build --cache-from ${DOCKER_IMAGE_LATEST} -t ${DOCKER_IMAGE_LATEST} ."
                    }
                }
            }
        }
        
        //need test stage

        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    script {
                        sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin ${DOCKER_PLATFORM}
                        '''

                        retry(3) {
                            sh "docker push ${DOCKER_IMAGE_LATEST}"
                        }
                    }
                }
            }
        }

        // stage('Generate Ansible Inventory') {
        //     steps {
        //         script {
        //              withCredentials([file(credentialsId: 'Depi-app-key.pem', variable: 'SSH_PRIVATE_KEY')]) {   
        //                 dir('terraform-ec2/') {
        //                     // Retrieve EC2 public IPs from Terraform output
        //                     def ec2Ips = sh(script: "terraform output -json ec2_public_ips", returnStdout: true).trim()

        //                     // Write the inventory file with the IPs
        //                     writeFile file: 'inventory.ini', text: """
        //                     [ec2_instances]
        //                     ${ec2Ips.split('\n').collect { it + " ansible_user=ubuntu ansible_ssh_private_key_file=${SSH_PRIVATE_KEY}" }.join('\n')}
        //                     """
        //                 }
        //              }
        //         }
            
        //         // For debugging purposes, print the contents of the generated inventory file
        //         sh 'cat terraform-ec2/inventory.ini'
        //     }
        // }

        // stage('Generate Ansible Inventory') {
        //     steps {
        //         // Wait until the EC2 instances have been created
        //         script {
        //             dir('terraform-ec2/') { 
        //             // Get the output of the EC2 public IPs from the module
        //             def ec2Ips = sh(script: "terraform output -json ec2_public_ips", returnStdout: true).trim()
        //             sh ''' terraform output -json ec2_public_ips | jq -r '.[]' > inventory2.ini '''

        //             // Write the inventory file
        //             writeFile file: 'inventory.ini', text: """
        //             [ec2_instances]
        //             ${ec2Ips.split('\n').collect { it + " ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/Depi-app-key.pem" }.join('\n')}
        //             """
        //             }
        //         }
                
        //         sh '''
        //             echo "[ec2_instances]" > terraform-ec2/inventory2.ini
        //             terraform output -json ec2_public_ips | jq -r '.[] | . + " ansible_ssh_private_key_file=/var/lib/jenkins/workspace/react-docker-pipeline/ssh17063419242249076167.key ansible_user=ubuntu"' >> terraform-ec2/inventory2.ini

        //             cat terraform-ec2/inventory.ini
        //             cat inventory.ini
        //             echo "---------------"
        //             cat terraform-ec2/inventory2.ini
        //             cat inventory2.ini
        //             '''
        //     }
        // }

        // stage('Run Ansible Playbook') {
        //     steps {
        //         // Run Ansible with the inventory
        //         sh 'ansible-playbook -i terraform-ec2/inventory.ini deploy_docker.yml'
        //     }
        // }

        // stage('Run Ansible Playbook') {
        //     steps {
        //         script {
        //             ansiblePlaybook(
        //                 playbook: 'deploy_docker.yml',
        //                 inventory: 'terraform-ec2/inventory.ini',
        //                 credentialsId: 'Depi-app-key.pem',
        //                 extras: "-e docker_image=${DOCKER_IMAGE_LATEST}"
        //             )
        //         }
        //     }
        // }
    }

    post {
        success {
            emailext(
                subject: "SUCCESS: Job '${env.JOB_NAME}' (${env.BUILD_NUMBER})",
                body: "Good news! The build was successful.\n\nCheck it out here: ${env.BUILD_URL}",
                to: 'engahmedharse@gmail.com'
            )
        }
        failure {
            emailext (
                subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>FAILURE: Job ${env.JOB_NAME} Build #${env.BUILD_NUMBER} has failed.</p>
                         <p>Check the build details <a href="${env.BUILD_URL}">here</a>.</p>""",
                to: 'engahmedharse@gmail.com',
                mimeType: 'text/html'
            )
        }
        always {
            // Echo message to log the cleanup
            echo 'Cleaning up workspace'

            // Cleanup workspace ##remove currently to no install everytime 
            // cleanWs()
            // sh '''
            //     # Remove everything except the .terraform directory
            //     find . -mindepth 1 ! -name '.terraform' -print
            //     find . -mindepth 1 ! -name '.terraform' -exec rm -rf {} +
            // '''

        // success {
        //     emailext (
        //         subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        //         body: """<p>SUCCESS: Job ${env.JOB_NAME} Build #${env.BUILD_NUMBER} was successful.</p>
        //                  <p>Check the build details <a href="${env.BUILD_URL}">here</a>.</p>""",
        //         to: 'engahmedharse@gmail.com',
        //         mimeType: 'text/html'
        //     )
        // }
        // failure {
        //     emailext (
        //         subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        //         body: """<p>FAILURE: Job ${env.JOB_NAME} Build #${env.BUILD_NUMBER} has failed.</p>
        //                  <p>Check the build details <a href="${env.BUILD_URL}">here</a>.</p>""",
        //         to: 'engahmedharse@gmail.com',
        //         mimeType: 'text/html'
        //     )
        // }
            // Additional cleanup commands
            script {
                sh "docker rmi ${DOCKER_IMAGE_LATEST} || true"
                sh 'docker system prune -f'
                sh 'docker logout'
            }
        }
    }
}


// pipeline {
//   agent any

//   // parameters {
//   //   string(name: 'DOCKER_REGISTRY', defaultValue: 'docker.io', description: 'Docker registry to push to')
//   //   string(name: 'DOCKER_REGISTRY_CREDS', defaultValue: 'docker-registry-credentials', description: 'Docker registry credentials')
//   // }

//   environment {
//     APP_NAME = 'my-react-app'
//     DOCKER_IMAGE_LATEST = "${DOCKER_REGISTRY}/${APP_NAME}:latest"
//     // DOCKER_IMAGE_TAGGED = "${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER}"
//     // TEST_IMAGE = "${APP_NAME}-test"
//     DOCKER_PLATFORM = "docker.io"
//   }

//   stages {
//     stage('Build') {
//       steps {
//         timeout(time: 20, unit: 'MINUTES') {
//           script {
//             // Build the Docker image using multi-stage Dockerfile with caching
//             // sh "docker build --cache-from ${DOCKER_IMAGE_LATEST} -t ${DOCKER_IMAGE_LATEST} -t ${DOCKER_IMAGE_TAGGED} ."
//             sh "docker build --cache-from ${DOCKER_IMAGE_LATEST} -t ${DOCKER_IMAGE_LATEST} ."
//           }
//         }
//       }
//     }

//     // stage('Test') {
//     //   steps {
//     //     script {
//     //       // Run tests in the Node.js build stage before the image is finalized
//     //       sh 'docker run --rm --entrypoint npm ${DOCKER_IMAGE_LATEST} run test'
//     //     }
//     //   }
// // }

//     stage('Push') {
//       steps {
//         withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
//           script {
//             // Login to Docker
//             sh '''
//               echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin ${DOCKER_PLATFORM}
//             '''

//             // Retry push in case of network issues
//             retry(3) {
//               sh "docker push ${DOCKER_IMAGE_LATEST}"
//               // sh "docker push ${DOCKER_IMAGE_TAGGED}"
//             }
//           }
//         }
//       }
//     }
//     // ansible-playbook -i inventory.ini deploy_docker.yml
    
//   }

//   post {
//     always {
//       script {
//         // Clean up Docker images locally to free up space
//         // sh "docker rmi ${DOCKER_IMAGE_LATEST} ${DOCKER_IMAGE_TAGGED} ${TEST_IMAGE} || true" // ignore error if image is not found
//         sh "docker rmi ${DOCKER_IMAGE_LATEST} || true" // ignore error if image is not found
//         sh 'docker system prune -f'
//         sh 'docker logout'
//       }
//     }
//   }
// }










// pipeline {
//   agent any

//   // parameters {
//   //   string(name: 'DOCKER_REGISTRY', defaultValue: 'docker.io', description: 'Docker registry to push to')
//   //   string(name: 'DOCKER_REGISTRY_CREDS', defaultValue: 'docker-registry-credentials', description: 'Docker registry credentials')
//   // }

//   environment {
//     APP_NAME = 'my-react-app'
//     DOCKER_IMAGE_LATEST = "${DOCKER_REGISTRY}/${APP_NAME}:latest"
//     DOCKER_IMAGE_TAGGED = "${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER}"
//   }

//   stages {
//     stage('Build') {
//       steps {
//         timeout(time: 20, unit: 'MINUTES') {
//           script {
//             // Build the Docker image using multi-stage Dockerfile with caching
//             sh 'docker build --cache-from ${DOCKER_IMAGE_LATEST} -t ${DOCKER_IMAGE_LATEST} -t ${DOCKER_IMAGE_TAGGED} .'
//           }
//         }
//       }
//     }

//     stage('Test') {
//       steps {
//         script {
//           // Run tests in the build stage of the Dockerfile, where npm is available
//           sh 'docker run --rm --entrypoint "" ${DOCKER_IMAGE_LATEST} npm run test'
//         }
//       }
//     }

//     stage('Deploy') {
//       steps {
//         withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
//           script {
//             // Login to Docker
//             sh '''
//                 echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin ${DOCKER_REGISTRY}
//             '''

//             // Retry push in case of network issues
//             retry(3) {
//               sh 'docker push ${DOCKER_IMAGE_LATEST}'
//               sh 'docker push ${DOCKER_IMAGE_TAGGED}'
//             }
//           }
//         }
//       }
//     }
//   }

//   post {
//     always {
//       script {
//         // Clean up Docker images locally to free up space
//         sh 'docker rmi ${DOCKER_IMAGE_LATEST} ${DOCKER_IMAGE_TAGGED} || true' // ignore error if image is not found
//         sh 'docker system prune -f'
//         sh 'docker logout'
//       }
//     }
//   }
// }




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
