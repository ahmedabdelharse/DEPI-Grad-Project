pipeline {
    agent any

    stages {
        stage('Copy Files') {
            steps {
                script {
                    // Execute the SCP command to copy files
                    sh 'scp -r /var/lib/jenkins/workspace/ansible-jenkins-pipeline/* root@52.90.151.102:~/project/'
                }
            }
        }
        
        stage('Run Ansible Playbook') {
            steps {
                script {
                    // Execute the Ansible playbook
                    sh 'ansible-playbook /var/lib/jenkins/playbooks/deployment.yml'
                }
            }
        }
    }

    environment {
        // Define any environment variables here, if needed
        // EXAMPLE_VAR = 'value'
    }
}
