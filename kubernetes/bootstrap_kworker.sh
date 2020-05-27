#!/bin/bash

#  Adaugare nod in clusterul de Kubernetes
echo "[TASK 1] Adaugare nod in clusterul de Kubernetes"
yum install -q -y sshpass >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kmaster.local.net:/joincluster.sh /joincluster.sh 2>/dev/null
bash /joincluster.sh >/dev/null 2>&1
