#! /bin/bash

## This startup script runs ON the compute vm

BUCKET_NAME=container_files
JAR_NAME=imageProcess-0.0.1-SNAPSHOT.jar
DOCKER_FILE=Dockerfile
SUPERVISOR=supervisor.conf


sudo su -

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

mkdir /opt/gcecontfull/docker

gsutil cp -r gs://${BUCKET_NAME}/${JAR_NAME} /opt/gcedeploy/docker/${JAR_NAME}
gsutil cp -r gs://${BUCKET_NAME}/${DOCKER_FILE} /opt/gcedeploy/docker/${DOCKER_FILE}
gsutil cp -r gs://${BUCKET_NAME}/${SUPERVISOR} /opt/gcedeploy/docker/${SUPERVISOR}

cd /opt/gcedeploy/docker
docker build -t imageprocess .

usermod -a -G docker dd-agent

sudo docker run --rm -p 8091:8091 imageprocess

DD_API_KEY=3412ddee5883e5661418c4891737b19b bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)"

exit
