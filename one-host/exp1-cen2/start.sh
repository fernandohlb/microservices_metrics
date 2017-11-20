#! /bin/bash

BUCKET_NAME=exp1-cen2-bucket

JAR_NAME=imageProcess-0.0.1-SNAPSHOT.jar
DOCKER_FILE=Dockerfile
SUPERVISOR=supervisor.conf

VM_NAME=exp1-cen2

gsutil mb gs://${BUCKET_NAME}
gsutil cp ./${JAR_NAME} gs://${BUCKET_NAME}/${JAR_NAME}
gsutil cp ./${DOCKER_FILE} gs://${BUCKET_NAME}/${DOCKER_FILE}
gsutil cp ./${SUPERVISOR} gs://${BUCKET_NAME}/${SUPERVISOR}

gcloud compute firewall-rules create ${VM_NAME}-www --allow tcp:8091 --target-tags ${VM_NAME}

gcloud compute instances create ${VM_NAME} \
  --tags ${VM_NAME} \
  --zone us-east4-a  --machine-type n1-standard-1 \
  --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud \
  --metadata-from-file startup-script=install.sh
