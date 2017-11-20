#! /bin/bash

BUCKET_APP_NAME=exp1-cen3-app-bucket
BUCKET_DB_NAME=exp1-cen3-db-bucket

JAR_NAME=imageProcess-0.0.1-SNAPSHOT.jar
DOCKER_FILE=Dockerfile

VM_NAME=exp1-cen3

#Copia os dados do Java
gsutil mb gs://${BUCKET_APP_NAME}
gsutil cp ./Docker_java/${JAR_NAME} gs://${BUCKET_APP_NAME}/${JAR_NAME}
gsutil cp ./Docker_java/${DOCKER_FILE} gs://${BUCKET_APP_NAME}/${DOCKER_FILE}

#Copia os dados do Mongodb
gsutil mb gs://${BUCKET_DB_NAME}/
gsutil cp ./Docker_mongodb/${DOCKER_FILE} gs://${BUCKET_DB_NAME}/${DOCKER_FILE}


gcloud compute firewall-rules create ${VM_NAME}-www --allow tcp:8091 --target-tags ${VM_NAME}

gcloud compute instances create ${VM_NAME} \
  --tags ${VM_NAME} \
  --zone us-east4-a  --machine-type n1-standard-1 \
  --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud \
  --metadata-from-file startup-script=install.sh
