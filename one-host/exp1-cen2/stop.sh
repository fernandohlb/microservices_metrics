#! /bin/bash
VM_NAME=exp1-cen2

gcloud compute firewall-rules delete --quiet ${VM_NAME}-www
gcloud compute instances delete --quiet --zone=us-east4-a ${VM_NAME}
