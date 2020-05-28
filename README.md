# Provizionare infrastructura

Infrastructura propusa aici cuprinde:
 - o instalare de Jenkins server in docker cu volume persistente
 - o instalare de Nexus server in docker cu volume persistente
 - un cluster de Kubernetes instalat pe 3 masini virtuale provizionate si configurate automat cu vagrant si virtualbox

Am ales sa instalez Jenkins si Nexus separat de clusterul de Kubernetes special pentru a putea pune in evidenta in mod distinct modul de functionare al sistemului de containere docker.
Atat Jenkins server cat si Nexus ar putea rula foarte similar direct in Kubernetes.
In modelul prezentat aici Kubernetes are rol de mediu tinta, in care aplicatia ruleaza.

## Systeme de operare suportate:
 - ubuntu linux
 - centos - programele de mai jos trebuie sa fie instalate corespunzator
 - orice alta distributie de linux care permite instalarea programelor necesare

## Instrumente necesare si pasi de instalare:

 - docker-ce - pentru a putea rula containere docker pe host
 ```
 sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io
```
 - docker-compose - pentru a putea porni mai multe containere

 `sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`

 - local-persist - pentru a putea specifica calea volumelor pe disk

 `curl -fsSL https://raw.githubusercontent.com/MatchbookLab/local-persist/master/scripts/install.sh | sudo bash`

 - kubectl - pentru a putea interactiona de pe masina gazda cu clusterul de Kubernetes

 ```
 sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
 curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
 echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

 sudo apt-get install -y kubectl
```

 - virtualbox - pentru a rula masini virtuale

 `sudo apt install virtualbox`

 - vagrant - pentru a putea automatiza procesul de creare, instalare si configurare a clusterului de Kubernetes pe masini virtuale

 ```
 wget https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb
 sudo apt install ./vagrant_2.2.9_x86_64.deb

 vagrant plugin install vagrant-scp
 ```

 - git - pentru a putea clona acest repozitor - Exista si alternativa de a descarca formatul arhiva din github

 `sudo apt install git`

 - make - pentru a putea porni infrastructura in mod simplificat folosind makefile

 `sudo apt-get install build-essential`

 - creeaza structura de directoare necesara pentru persistenta datelor

 ```
 sudo mkdir -p /opt/jenkins/data
 sudo mkdir -p /opt/jenkins/log
 sudo mkdir -p /opt/jenkins/ssl
 chown -R 1001:1001 /opt/jenkins/*
 sudo mkdir -p /opt/nexus/data
 chown -R 200.200 /opt/nexus/data
```

## Pornirea si provizionarea infrastructurii
Vor fi executate pe rand comenzile afisate in makefile.

1. Cloneaza acest repozitor

`git clone https://github.com/adrianiacob22/provizionare_infrastructura.git`

2. Porneste intreaga suita
 - Pornirea si provizionarea va dura aproximativ 20 de minute pe un mediu nou

```
  cd provizionare_infrastructura/
  make
```

3. Verifica starea mediului

`make status`

4. Dupa ce mediul a pornit copiem fisierul de configurare pentru apelarea api-ului de kubernetes

`vagrant scp kmaster:/home/vagrant/.kube/config ~/.kube/config`

5. Verificam starea clusterului de Kubernetes ruland comenzile urmatoare

 - starea clusterului

`kubectl cluster-info`

 - starea nodurilor

`kubectl get nodes`

## Pornirea pe componente

1. Cloneaza acest repozitor

`git clone https://github.com/adrianiacob22/provizionare_infrastructura.git`

2. Porneste jenkins si nexus

```
  cd provizionare_infrastructura/jenkins
  docker-compose up -d
```

3. Porneste masinile virtuale folosind vagrant

```
  cd provizionare_infrastructura/kubernetes
  vagrant up
```

4. Dupa ce mediul a pornit

4.1. Verificam starea masinilor virtuale

`vagrant status`

```
Current machine states:

kmaster                   running (virtualbox)
kworker1                  running (virtualbox)
kworker2                  running (virtualbox)
```

4.2. Copiem fisierul de configurare pentru apelarea api-ului de kubernetes

`vagrant scp kmaster:/home/vagrant/.kube/config ~/.kube/config`

5. Verificam starea clusterului de Kubernetes ruland comenzile urmatoare

 - starea clusterului

`kubectl cluster-info`

 - starea nodurilor

`kubectl get nodes`
