#! /bin/bash

## This startup script runs ON the compute vm
BUCKET_NAME=exp2-cen1-bucket

JAR_NAME=imageProcess-0.0.1-SNAPSHOT.jar
DOCKER_FILE=Dockerfile
DOCKER_COMPOSE_FILE=docker-compose.yml
SUPERVISOR=supervisor.conf
TELEGRAF=telegraf.conf



sudo su -

#Instala o Docker
apt-get update

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get install -y docker-ce

apt-get update

service docker start


#Implanta a Aplicacao
mkdir /opt/docker

gsutil cp -r gs://${BUCKET_NAME}/${JAR_NAME} /opt/docker/${JAR_NAME}
gsutil cp -r gs://${BUCKET_NAME}/${DOCKER_FILE} /opt/docker/${DOCKER_FILE}
gsutil cp -r gs://${BUCKET_NAME}/${SUPERVISOR} /opt/docker/${SUPERVISOR}
gsutil cp -r gs://${BUCKET_NAME}/${DOCKER_COMPOSE_FILE} /opt/docker/${DOCKER_COMPOSE_FILE}
gsutil cp -r gs://${BUCKET_NAME}/${TELEGRAF} /opt/docker/${TELEGRAF}

cd /opt/docker

docker build --tag=imageprocess-exp2-cen1 .

docker run -d --name imageprocess-exp2-cen1-w1 --net bridge -p 8091:8091 -p 27017:27017  imageprocess-exp2-cen1

exit
