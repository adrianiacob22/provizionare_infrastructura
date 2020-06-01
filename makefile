export VAGRANT_CWD=${PWD}/kubernetes

default: run
jstart:
	@echo "======= Pornesc containerele docker pentru Jenkins si Nexus ==========="
	@docker-compose -p jenkins -f jenkins/docker-compose.yml up -d
	@echo "======================================================================="
jstop:
	@echo "========= Opresc containerele docker (Jenkins si Nexus)================"
	@docker-compose -p jenkins -f jenkins/docker-compose.yml down
	@echo "======================================================================="
jstat:
	@echo "============== Afiseaza starea containerelor =========================="
	@docker-compose -p jenkins -f jenkins/docker-compose.yml ps
	@echo "======================================================================="
kubestart:
	@echo "========== Pornesc masinile virtuale pentru Kubernetes ================"
	@vagrant up
	@echo "======================================================================="
kubestat:
	@echo "================= Afiseaza starea vm-urilor ==========================="
	@vagrant status
	@echo "======================================================================="
kubestop:
	@echo "================= Opreste mediul Kubernetes ==========================="
	@vagrant halt
	@echo "======================================================================="
run: jstart kubestart
stop: jstop kubestop
status: jstat kubestat
	@echo "============= Starea nodurilor din clusterul Kubernetes ==============="
	@kubectl get nodes
	@echo "======================================================================="
