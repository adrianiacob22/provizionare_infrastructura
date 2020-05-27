default: run
build:
	@docker-compose -p jenkins build
run:
	@docker-compose -p jenkins up -d
stop:
	@docker-compose -p jenkins down
logs:
	@docker-compose logs
clean-data:
	@docker-compose -p jenkins down -v
clean-images:
	@docker rmi `docker images -q -f "dangling=true"`
jenkins-log:
	@docker-compose -p jenkins exec master tail -f /var/log/jenkins/jenkins.log
# Variabila de mai jos contine locatia de pe masina gazda unde se afla certificatele
CERT_PATH := /opt/jenkins/ssl/
certs:
	echo "----> Creating nginx certificates..." && \
	sudo openssl req -writerand -new -newkey rsa:4096 -days 3650 -nodes -x509 \
	-subj "/C=RO/ST=Romania/L=Bucharest/O=UTM/CN=jenkins" \
	-keyout $(CERT_PATH)server.key -out $(CERT_PATH)server.crt && \
	echo "=============>Certificates are created in $(CERT_PATH)<============="
JENKINS := /opt/jenkins
LOG_PATH := /opt/jenkins/log
DATA_PATH := /opt/jenkins/data
volumes:
	echo "Creating local folders for docker persistent volumes:"
	sudo mkdir -v -p $(CERT_PATH) $(LOG_PATH) $(DATA_PATH) && \
	sudo chown -R 1001:1001 $(JENKINS)
	echo "> Local folders for docker persistent volumes are created <"
initial: volumes certs build run
