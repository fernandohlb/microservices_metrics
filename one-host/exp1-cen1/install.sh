#! /bin/bash

## This startup script runs ON the compute vm

BUCKET_NAME=exp1-cen1-bucket
JAR_NAME=imageProcess-0.0.1-SNAPSHOT.jar

sudo su -

#Instala o Java
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list

echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get update

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get install oracle-java8-installer -y

#Instala o MongoDB
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list-3.0.list
apt-get update
apt-get install -y mongodb-org
apt-get update

service mongod start


#Inicializa a Aplicacao
mkdir /opt/exp1-cen1

gsutil cp gs://${BUCKET_NAME}/${JAR_NAME} /opt/exp1-cen1/${JAR_NAME}
java -jar /opt/exp1-cen1/${JAR_NAME} &

exit
