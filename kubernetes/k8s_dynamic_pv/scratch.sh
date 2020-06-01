# Install and configure nfs server on ubuntu
sudo apt-get install nfs-kernel-server

sudo systemctl restart nfs-kernel-server

# Dinamic volumes
sudo mkdir -p /srv/nfs/k8sdata
echo "/srv/nfs/k8sdata *(rw,sync,no_subtree_check)" |sudo tee -a /etc/exports
sudo chown -R nfsnobody:nfsnobody /srv/nfs/k8sdata
sudo chmod -R 755 /srv/nfs/k8sdata
sudo exportfs -rav
sudo systemctl restart nfs-server

# install nfs client to test the connection
sudo apt-get install nfs-common
sudo mount 172.42.42.1:/srv/nfs/k8sdata /mnt/

touch /mnt/$(hostname)
sudo umount /mnt

# then do:

cd kubernetes/k8s_dynamic_pv
kubectl create -f rbac.yaml
kubectl create -f class.yaml
kubectl  create -f deployment.yaml

# Deploy jenkins
# namespace jenkins should be manually created
helm upgrade --install jenkins --namespace jenkins --values jenkins_values.yml stable/jenkins




cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: jenkins-data
spec:
  capacity:
    storage: 8Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: 172.42.42.1
    path: /export/data/jenkins/
EOF

## Installing tekton pipelines on K8S
kubectl apply --filename https://storage.googleapis.com/tekton-releases/latest/release.yaml

# Install tekton dashboard

kubectl apply --filename https://github.com/tektoncd/dashboard/releases/download/v0.1.1/release.yaml

# Change tekton service type to loadbalancer in order to be able tu access the dashboard
kubectl patch service tekton-dashboard -n tekton-pipelines -p '{"spec": {"type": "LoadBalancer"}}'

## Deploy Tekton Webhooks extension
