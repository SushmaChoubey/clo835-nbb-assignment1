#!/bin/bash
sudo yum update -y
sudo yum install docker -y
#For ping install
sudo yum install iputils -y
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo systemctl start docker
export ECR=983372048879.dkr.ecr.us-east-1.amazonaws.com/clo835-assigmt1-repo
export DB_IMG=my_db_img
export APP_IMG=my_app_img
export DBPORT=3306
export DBUSER=root
export DATABASE=employees
export DBPWD=db_pass123
export APP_COLOR_BLUE=blue
export APP_COLOR_LIME=lime
export APP_COLOR_PINK=pink

#Login into ECR repository
aws ecr get-login-password --region us-east-1 |sudo docker login -u AWS ${ECR} --password-stdin
#Pull DB image and run DB container
#sudo docker run -d -e MYSQL_ROOT_PASSWORD=${DBPWD} --name mysql-db ${ECR}:${DB_IMG}
sudo docker network create schoubey-network
sudo docker run -d -p 8080:8080 -e MYSQL_ROOT_PASSWORD=${DBPWD} --name mysql-db --network=schoubey-network ${ECR}:${DB_IMG}
export DBHOST=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql-db)
echo 'my db host value' $DBHOST
sudo docker run -d --name blue-container -p 8081:8080 --network=schoubey-network -e APP_COLOR=$APP_COLOR_BLUE -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD ${ECR}:${APP_IMG}
sudo docker run -d --name pink-container -p 8082:8080 --network=schoubey-network -e APP_COLOR=$APP_COLOR_PINK -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD ${ECR}:${APP_IMG}
sudo docker run -d --name lime-container -p 8083:8080 --network=schoubey-network -e APP_COLOR=$APP_COLOR_LIME -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD ${ECR}:${APP_IMG}
EOF
