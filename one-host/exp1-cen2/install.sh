#! /bin/bash

## This startup script runs ON the compute vm

BUCKET_NAME=exp1-cen2-bucket
JAR_NAME=imageProcess-0.0.1-SNAPSHOT.jar
DOCKER_FILE=Dockerfile
SUPERVISOR=supervisor.conf


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
mkdir /opt/exp1-cen2/docker

gsutil cp -r gs://${BUCKET_NAME}/${JAR_NAME} /opt/exp1-cen2/docker/${JAR_NAME}
gsutil cp -r gs://${BUCKET_NAME}/${DOCKER_FILE} /opt/exp1-cen2/docker/${DOCKER_FILE}
gsutil cp -r gs://${BUCKET_NAME}/${SUPERVISOR} /opt/exp1-cen2/docker/${SUPERVISOR}

cd /opt/exp1-cen2/docker
docker build --tag=imageprocess-exp1-cen2 .


docker run -d --name imageprocess-exp1-cen2 -p 8091:8091  imageprocess-exp1-cen2


exit
