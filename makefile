setup:
	bash setup/bootstrap.sh

gpg:
	bash setup/setup-gpg-ci.sh

docker:
	bash setup/install-docker.sh

trivy:
	bash setup/install-trivy.sh

node:
	bash setup/install-nvm.sh

git:
	bash setup/setup-git.sh
