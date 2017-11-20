#! /bin/bash

## This startup script runs ON the compute vm

BUCKET_APP_NAME=exp1-cen3-app-bucket
BUCKET_DB_NAME=exp1-cen3-db-bucket

JAR_NAME=imageProcess-0.0.1-SNAPSHOT.jar
DOCKER_FILE=Dockerfile


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


#Implanta o Docker do MongoDB
mkdir /opt/exp1-cen3/docker_mongo

#gsutil cp -r gs://${BUCKET_NAME}/${JAR_NAME} /opt/exp1-cen2/docker/${JAR_NAME}
gsutil cp -r gs://${BUCKET_DB_NAME}/${DOCKER_FILE} /opt/exp1-cen3/docker_mongo/${DOCKER_FILE}


cd /opt/exp1-cen3/docker_mongo
docker build --tag=mongodb-exp1-cen3 .

mkdir -p ~/mongo-data

#Cria a rede para comunicacao entre os Dockers
docker network create image-process-net 

docker run --name mongodb-exp1-cen3 --network=image-process-net -v ~/mongo-data:/data/db -d mongodb-exp1-cen3

#Implanta o Docker da Aplicacao
mkdir /opt/exp1-cen3/docker_app
gsutil cp -r gs://${BUCKET_APP_NAME}/${JAR_NAME} /opt/exp1-cen3/docker_app/${JAR_NAME}
gsutil cp -r gs://${BUCKET_APP_NAME}/${DOCKER_FILE} /opt/exp1-cen3/docker_app/${DOCKER_FILE}

cd /opt/exp1-cen3/docker_app
docker build --tag=image-process-app-exp1-cen3 .

docker run -d --name image-process-app-exp1-cen3 --network=image-process-net -p 8091:8091  image-process-app-exp1-cen3

exit
