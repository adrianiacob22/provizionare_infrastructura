# Kubernetes Cluster with Containerd
<p align="center">
<img src="https://kubernetes.io/images/favicon.png" width="50" height="50">
<img src="https://containerd.io/img/logos/icon/black/containerd-icon-black.png" width="50" >
</p>


This document provides the steps to bring up a Kubernetes cluster using ansible and kubeadm tools.

### Prerequisites:
- **OS**: Ubuntu 16.04 (will be updated with additional distros after testing)
- **Python**: 2.7+
- **Ansible**: 2.4+

## Step 0:
-  Install Ansible on the host where you will provision the cluster. This host may be one of the nodes you plan to include in your cluster. Installation instructions for Ansible are found [here](http://docs.ansible.com/ansible/latest/intro_installation.html).
-  Create a hosts file and include the IP addresses of the hosts that need to be provisioned by Ansible.
-  Since this playbook is designed to work as well with vagrant provisioner, make sure the host which is planned to be master has the "master" keyword inside the hostname
```console
$ cat hosts
172.31.7.230
172.31.13.159
172.31.1.227
```
-  Setup passwordless SSH access from the host where you are running Ansible to all the hosts in the hosts file. The instructions can be found in [here](http://www.linuxproblem.org/art_9.html)

## Step 1:
At this point, the ansible playbook should be able to ssh into the machines in the hosts file. From inside current directory run:
```console
ansible-playbook -i hosts cri-containerd.yaml
```
A typical cloud login might have a username and private key file, in which case the following can be used:
```console
ansible-playbook -i hosts -u <username> --private-key <example.pem> cri-containerd.yaml
 ```
## Step 2:
At this point the entire Kubernetes cluster should be up and running.
On master node just run:

```console
kubectl get nodes
```
