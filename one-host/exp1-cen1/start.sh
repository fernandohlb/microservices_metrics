#! /bin/bash

BUCKET_NAME=exp1-cen1-bucket

JAR_NAME=imageProcess-0.0.1-SNAPSHOT.jar
VM_NAME=exp1-cen1

gsutil mb gs://${BUCKET_NAME}
gsutil cp ./${JAR_NAME} gs://${BUCKET_NAME}/${JAR_NAME}

gcloud compute firewall-rules create ${VM_NAME}-www --allow tcp:8091 --target-tags ${VM_NAME}

gcloud compute instances create ${VM_NAME} \
  --tags ${VM_NAME} \
  --zone us-east4-a  --machine-type n1-standard-1 \
  --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud \
  --metadata-from-file startup-script=install.sh
