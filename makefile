default: run
jstart:
	@echo "================ Pornesc containerele docker =========================="
	@docker-compose -p jenkins -f jenkins/docker-compose.yml up -d
	@echo "======================================================================="
jstop:
	@echo "================ Opreste containerele docker ========================="
	@docker-compose -p jenkins -f jenkins/docker-compose.yml down
	@echo "======================================================================="
jstat:
	@echo "============== Afiseaza starea containerelor =========================="
	@docker-compose -p jenkins -f jenkins/docker-compose.yml ps
	@echo "======================================================================="
kubestart:
	@echo "========== Pornesc masinile virtuale pentru Kubernetes ================"
	@export VAGRANT_CWD=$PWD/kubernetes
	@vagrant up
	@echo "======================================================================="
kubestat:
	@echo "================= Afiseaza starea vm-urilor ==========================="
	@export VAGRANT_CWD=$PWD/kubernetes
	@vagrant status
	@echo "======================================================================="
kubestop:
	@echo "================= Opreste mediul Kubernetes ==========================="
	@export VAGRANT_CWD=$PWD/kubernetes
	@vagrant halt
	@echo "======================================================================="
run: jstart kubestart
stop: jstop kubestop
status: jstat kubestat
	@echo "============= Starea nodurilor din clusterul Kubernetes ==============="
	@kubectl get nodes
	@echo "======================================================================="
