#! /bin/bash
FIREWALL=exp2-cen2

VM_NAME_MANAGER=exp2-cen2-mng
VM_NAME_WORKER_1=exp2-cen2-w1
VM_NAME_WORKER_2=exp2-cen2-w2

gcloud compute firewall-rules delete --quiet ${FIREWALL}-www
gcloud compute instances delete --quiet --zone=us-east4-a ${VM_NAME_MANAGER}
gcloud compute instances delete --quiet --zone=us-east4-a ${VM_NAME_WORKER_1}
gcloud compute instances delete --quiet --zone=us-east4-a ${VM_NAME_WORKER_2}
