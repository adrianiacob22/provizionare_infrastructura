joincluster=$(ssh -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET -o StrictHostKeyChecking=no root@k8s-master -t 'kubeadm token create --print-join-command 2>/dev/null' | grep -v validate)
hostname
echo ${joincluster}
sudo ${joincluster}
