PATHCI := ~/personal/laboratory/CI

setup-bootstrap:
	bash $(PATHCI)/setup/bootstrap.sh

setup-gpg:
	bash $(PATHCI)/setup/setup-gpg-ci.sh

setup-docker:
	bash $(PATHCI)/setup/install-docker.sh

setup-trivy:
	bash $(PATHCI)/setup/install-trivy.sh

setup-nvm:
	bash $(PATHCI)/setup/install-nvm.sh

setup-git:
	bash $(PATHCI)/setup/setup-git.sh

setup-permissions:
	find $(PATHCI)/setup/ -type f -name "*.sh" -exec chmod +x {} \;
	find $(PATHCI)/util/git -type f -name "*.sh" -exec chmod +x {} \;

util-git-restore-tags:
	bash util/git/restore-tags.sh
