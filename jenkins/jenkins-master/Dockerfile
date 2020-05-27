FROM jenkins/jenkins:lts-jdk11
# Din imaginea specificata mai sus, incep construirea unei noi imagini specifice
# adaugand detalii asa cu, sunt specificate mai jos.
LABEL maintainer="adrianiacob22@gmail.com"
# Comanda ENV defineste variabile ce sunt folosite in timpul procesului de build.
ENV refpath /usr/share/jenkins/ref/
ENV groovypath /usr/share/jenkins/ref/init.groovy.d/
ENV pluginpath /usr/share/jenkins/ref/plugins/
ENV uid 1001
# Aleg utilizatorul care va executa urmatorul set de comenzi.
USER root
# Comanda RUN executa comenzile specificate intr-un container pornit pe baza
# imaginii din FROM. Instalez programele necesare.
RUN apt-get update && apt-get install -y apt-utils ruby make
# Creez o structura de fisiere si asignez permisiuni pentru a porni
# serverul jenkins asa cum am nevoie.
RUN mkdir -p ${groovypath}  && \
    mkdir -p ${pluginpath}  && \
    usermod -u ${uid} jenkins  && \
    groupmod -g ${uid} jenkins  && \
    groupadd -g 978 docker && \
    usermod -a -G root jenkins && \
    usermod -a -G docker jenkins && \
    echo "jenkins  ALL=(ALL)       ALL" >> /etc/sudoers && \
    chown -R jenkins:jenkins /usr/share/jenkins/

## Adaug groovy scripts pentru automatizarea unor configuratii specifice de jenkins
COPY files/*.groovy ${groovypath}

# best-practice - schimb utilizatorul care va fi folosit in cadrul containerului
USER jenkins

# Setez o lista de parametri pe care ii voi folosi la pornirea serverului Jenkins.
ENV JAVA_OPTS="-Dcom.sun.akuma.Daemon=daemonized -Djava.awt.headless=true -DJENKINS_EMAIL=adrianiacob22@gmail.com -Xms1024m -Xmx4096m -Dhudson.model.ParametersAction.keepUndefinedParameters=true -Dhudson.model.DirectoryBrowserSupport.CSP= -Dhudson.tasks.MailSender.SEND_TO_UNKNOWN_USERS=true -Dhudson.tasks.MailSender.SEND_TO_USERS_WITHOUT_READ=true -Dhudson.remoting.ClassFilter=org.jfrog.build.api.Artifact,org.jfrog.build.api.BaseBuildFileBean,org.jfrog.build.api.BaseBuildBean -Dpermissive-script-security.enabled=true -XX:+UseG1GC -XX:+AlwaysPreTouch -XX:+UseStringDeduplication -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -DJENKINS_HOME=/var/jenkins_home -Djenkins.install.runSetupWizard=false -Djavax.net.ssl.trustStore=/usr/local/openjdk-11/lib/security/cacerts -Djavax.net.ssl.trustStorePassword=changeit"
ENV JENKINS_OPTS="--logfile=/var/log/jenkins/jenkins.log --webroot=/var/jenkins_home/war --daemon --httpPort=8080 --debug=5 --handlerCountMax=100 --handlerCountMaxIdle=20 --sessionTimeout=1440"
