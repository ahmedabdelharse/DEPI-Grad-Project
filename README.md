### Github Repo 
- Dockerfile (for the web app)
- The web app directory 
- Jenkinsfile 
- ansible playbook 
- ansible.cfg  (optional)
- ansible inventory file (optional)
 
### Docker
- Install docker (locally or on an EC2)
- Create the web app 
- Create a simple test file for the web app and test it 
- Create a Dockerfile 
	- install the library/framework to build the app 
	- install nginx and use the file of the built app 
- Create an image from the Docker file 
- Test it with creating a container
### AWS 
Using **Terraform**
- Two EC2 
- (or 3 for the **jenkins master**) (one **jenkins agent** ) and (one for the **web app** )
	- jenkins agent  must have 
		1. openjdk-11-jdk or later
		2. pip3 (for ansible installation)
		3. ansible
		4. git
		5. Docker (if you want to run docker on the agent) (not necessary if want to run the docker build part on the jenkins master but not recommended )
		6. must have the `key-pair.pem` for the **web-app EC2**
- VPC
- subnets
- Key-pair (must be moved into the jenkins agent and saved on the master machine)
- security groups
- route table
- internet gateway
- route table association
### Jenkins
- Install jenkins on the local machine or on a remote EC2 *(then we will need 3 EC2)*
	- can be installed as a docker container
		- (you will need docker in docker if you want to use docker scripts on the same machine)
	- or on the system 
- Create credentials for the jenkins agent ec2 (add the `key-pair.pem` as credentials)
	- need the `key-pair.pem` to copy the key from
- Create a node to connect to the jenkins agent ec2 (using the credentials)
	- create a label to the node
	- need the IP of the jenkins agent EC2
	- need the credentials that you created (name)
- Create a pipeline
	- triggers with github webhooks
	- run the Jenkinsfile on the GitHub repo 
- Create Jenkinsfile
	- Specify the agent that will run each part of the script (if you want to run part of it locally and part on the remote agent)
	- Clone The Repo
	- Run a Test for the web app (you will need to install the framework of the web app on the agent that will run this part)
	- Build the Docker image 
	- Push the Docker image to docker hub
	- Test the build
	- Run Ansible Playbook (with the remote agent)

### Ansible
- Ansible must be Installed on the Jenkins Agent 
- Create ansible.cfg
	- for the the web app EC2  (`key-piar.pem` & to set other configuration)
- Create inventory.ini (optional)
	- for the the web app EC2 IP
- Ansible playbook 
	- Install docker on web app EC2 
	- pull the image that was created with jenkins from docker hub
	- create a container from the image and  expose it to port 80 (for nginx default port)
- Test if the website is available from the public IP of the web app EC2