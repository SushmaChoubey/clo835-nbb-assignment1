# clo835-nbb-assignment1

Create Dockerfile, build docker image and deploy docker container on Amazon Linux EC2

Pre-requisites
--------------
1. Connecting to the GitHub Account with SSH - For connecting the Development Environment with the GitHub, we will generate 
the SSH key using command.
```ssh-keygen -t rsa -f keyName```
Copy the public key under our GitHub account on path 
```-> Settings ->SSH and GPG key ->Add SSH key.```
2. Copy AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN of the Cloud9 environment in the GitHub Repository under
the path ```->Settings ->Actions secrets and variables```
This will be needed for pushing Docker images into the Amazon ECR repository.

Folder Hierarchy
----------------
1. GitHub actions to create docker images and push them to Amazon ECR is stored under the path.
```clo835-nbb-assignment1/.github/workflows/```
2. DockerFile for creating the Application Image is kept under the path.
```clo835-nbb-assignment1/application/```
3. DockerFile for creating the MySQL Image is kept under the path.
```clo835-nbb-assignment1/application/db/```
4. Terraform code to create Amazon ECR to securely store container images is under the path.
```clo835-nbb-assignment1/terraform_code/dev/ecr/```
5. Terraform code to create Amazon EC2 to host containerized application is under the path.
```clo835-nbb-assignment1/terraform_code/dev/instances/```
6. Code for running the application container and MySQL container is under the path.
```clo835-nbb-assignment1/terraform_code/dev/instances/install_httpd.sh```

Application Flow
----------------
1. Create the Amazon ECR Repository using the Terraform Code. 
Browse to the folder ```clo835-nbb-assignment1/terraform_code/dev/ecr/```
.Run below commands
```tf plan```
```tf apply -auto-approve```
2. Merge the feature branch to the master branch, this will trigger the GitHub Actions and push the docker images for
the application and database inside the ECR repository.
3. Therafter, create the Amazon EC2 instance, using the Terraform Code. 
Browse to the folder ```clo835-nbb-assignment1/terraform_code/dev/instances/```
.Run below commands
```tf plan```
```tf apply -auto-approve```

The install_httpd.sh script will provision the EC2 and enable docker, pull the docker images from the ECR repository 
and launch the MySQL DB container and 3 application containers under the custom bridge network named "schoubey-network"

blue-container on port 8081,
pink-container on port 8082,
lime-container on port 8083

4. Therafter, when we try to access the application using below urls it should be accesible

#Application with Blue Background
    http://publicIpEC2:8081/ 
#Application with Pink Background
    http://publicIpEC2:8082/ 
#Application with Lime Background
    http://publicIpEC2:8083/ 

5. Additionally, on the EC2 instance, if we go under the blue-container using the command.
```docker exec -it blue-container /bin/bash```

We should be successfully able to ping the other two containers using the command.

```ping pink-container```
```ping lime-container```



Author Information
------------------
Sushma Choubey

Student No: 180698219
