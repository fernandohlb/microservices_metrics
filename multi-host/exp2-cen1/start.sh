#! /bin/bash

BUCKET_NAME=exp2-cen1-bucket

JAR_NAME=imageProcess-0.0.1-SNAPSHOT.jar
DOCKER_FILE=Dockerfile
DOCKER_COMPOSE_FILE=docker-compose.yml
SUPERVISOR=supervisor.conf
TELEGRAF=telegraf.conf


FIREWALL=exp2-cen1

VM_NAME_MANAGER=exp2-cen1-mng
VM_NAME_WORKER_1=exp2-cen1-w1
VM_NAME_WORKER_2=exp2-cen1-w2


gsutil mb gs://${BUCKET_NAME}
gsutil cp ./${JAR_NAME} gs://${BUCKET_NAME}/${JAR_NAME}
gsutil cp ./${DOCKER_FILE} gs://${BUCKET_NAME}/${DOCKER_FILE}
gsutil cp ./${SUPERVISOR} gs://${BUCKET_NAME}/${SUPERVISOR}
gsutil cp ./${DOCKER_COMPOSE_FILE} gs://${BUCKET_NAME}/${DOCKER_COMPOSE_FILE}
gsutil cp ./${TELEGRAF} gs://${BUCKET_NAME}/${TELEGRAF}

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
