setup-bootstrap:
	bash setup/bootstrap.sh

setup-gpg:
	bash setup/setup-gpg-ci.sh

setup-docker:
	bash setup/install-docker.sh

setup-trivy:
	bash setup/install-trivy.sh

setup-nvm:
	bash setup/install-nvm.sh

setup-git:
	bash setup/setup-git.sh

setup-permissions:
	find setup/ -type f -name "*.sh" -exec chmod +x {} \;
	find util/ -type f -name "*.sh" -exec chmod +x {} \;

util-git-restore-tags:
	bash util/git/restore-tags.sh
