#! /bin/bash

BUCKET_APP_NAME=exp2-cen2-app-bucket
BUCKET_DB_NAME=exp2-cen2-db-bucket
BUCKET_MONIT=exp2-cen2-monit-bucket

JAR_NAME=imageProcess-0.0.1-SNAPSHOT.jar
DOCKER_FILE=Dockerfile
DOCKER_COMPOSE_FILE=docker-compose.yml
TELEGRAF=telegraf.conf


FIREWALL=exp2-cen2

VM_NAME_MANAGER=exp2-cen2-mng
VM_NAME_WORKER_1=exp2-cen2-w1
VM_NAME_WORKER_2=exp2-cen2-w2


#Copia os dados do Java
gsutil mb gs://${BUCKET_APP_NAME}
gsutil cp ./Docker_java/${JAR_NAME} gs://${BUCKET_APP_NAME}/${JAR_NAME}
gsutil cp ./Docker_java/${DOCKER_FILE} gs://${BUCKET_APP_NAME}/${DOCKER_FILE}

#Copia os dados do Agente de monitoramento
gsutil mb gs://${BUCKET_MONIT}
gsutil cp ./Docker_telegraf/${DOCKER_COMPOSE_FILE} gs://${BUCKET_MONIT}/${DOCKER_COMPOSE_FILE}
gsutil cp ./Docker_telegraf/${TELEGRAF} gs://${BUCKET_MONIT}/${TELEGRAF}

#Copia os dados do Mongodb
gsutil mb gs://${BUCKET_DB_NAME}/
gsutil cp ./Docker_mongodb/${DOCKER_FILE} gs://${BUCKET_DB_NAME}/${DOCKER_FILE}



gcloud compute firewall-rules create ${FIREWALL}-www --allow tcp:8091 --target-tags ${FIREWALL}

gcloud compute instances create ${VM_NAME_MANAGER} \
  --tags ${FIREWALL} \
  --zone us-east4-a  --machine-type n1-standard-1 \
  --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud \
  --metadata-from-file startup-script=install_mng.sh

gcloud compute instances create ${VM_NAME_WORKER_1} \
  --tags ${FIREWALL} \
  --zone us-east4-a  --machine-type n1-standard-1 \
  --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud \
  --metadata-from-file startup-script=install_w1.sh

gcloud compute instances create ${VM_NAME_WORKER_2} \
  --tags ${FIREWALL} \
  --zone us-east4-a  --machine-type n1-standard-1 \
  --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud \
  --metadata-from-file startup-script=install_w2.sh
