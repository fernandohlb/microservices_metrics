#! /bin/bash

## This startup script runs ON the compute vm
BUCKET_APP_NAME=exp2-cen2-app-bucket
BUCKET_DB_NAME=exp2-cen2-db-bucket
BUCKET_MONIT=exp2-cen2-monit-bucket

JAR_NAME=imageProcess-0.0.1-SNAPSHOT.jar
DOCKER_FILE=Dockerfile
DOCKER_COMPOSE_FILE=docker-compose.yml
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

#Implanta o Docker do MongoDB
mkdir /opt/docker_mongo

gsutil cp -r gs://${BUCKET_DB_NAME}/${DOCKER_FILE} /opt/docker_mongo/${DOCKER_FILE}


cd /opt/docker_mongo
docker build --tag=mongodb-exp2-cen2 .

docker run -d --name mongodb-exp2-cen2-mng --net bridge -p 27017:27017 mongodb-exp2-cen2 --replSet rs0

mkdir -p ~/mongo-data

#Implanta o Docker da Aplicacao
mkdir /opt/docker_app
gsutil cp -r gs://${BUCKET_APP_NAME}/${JAR_NAME} /opt/docker_app/${JAR_NAME}
gsutil cp -r gs://${BUCKET_APP_NAME}/${DOCKER_FILE} /opt/docker_app/${DOCKER_FILE}

cd /opt/docker_app
docker build --tag=imageprocess-app-exp2-cen2 .

docker run -d --name imageprocess-exp2-cen2-mng --net bridge -p 8091:8091 imageprocess-app-exp2-cen2

#Copia os arquivos para monitoramento
mkdir /opt/docker_monit

gsutil cp -r gs://${BUCKET_MONIT}/${DOCKER_COMPOSE_FILE} /opt/docker_monit/${DOCKER_COMPOSE_FILE}
gsutil cp -r gs://${BUCKET_MONIT}/${TELEGRAF} /opt/docker_monit/${TELEGRAF}

exit
