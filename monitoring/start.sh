#! /bin/bash

VM_NAME=monitoring

gcloud compute firewall-rules create ${VM_NAME}-www --allow tcp:3000 --target-tags ${VM_NAME}

gcloud compute instances create ${VM_NAME} \
  --tags ${VM_NAME} \
  --zone us-east4-a  --machine-type n1-standard-1 \
  --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud \
  --metadata-from-file startup-script=install.sh
