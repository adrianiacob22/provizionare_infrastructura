FROM centos:centos7
LABEL maintainer="adrianiacob22@gmail.com"

# Instalez programele necesare
RUN yum update -y && \
  yum install -y git && \
  yum install -y wget && \
	yum install -y java-11-openjdk-devel && \
	yum install -y sudo && \
	yum clean all

# Configurez un utilizator sub id-ul caruia se vor executa build-urile
ARG user=jenkins
ARG group=jenkins
ARG uid=1001
ARG gid=1001

ENV JENKINS_HOME /home/${user}

RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user} \
    && usermod -g wheel ${user}

RUN chown -R ${user}:${user} /home/${user}

# Dau permisiuni de tip sudo utilizatorului
RUN echo "${user}    ALL=(ALL)    ALL" >> etc/sudoers
