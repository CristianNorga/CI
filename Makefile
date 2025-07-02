PATHCI := ~/personal/laboratory/CI

setup-bootstrap:
	bash $(PATHCI)/util/hooks/pre_job.sh
	bash $(PATHCI)/setup/bootstrap.sh
	bash $(PATHCI)/util/hooks/post_job.sh

setup-gpg:
	bash $(PATHCI)/util/hooks/pre_job.sh
	bash $(PATHCI)/setup/setup-gpg-ci.sh
	bash $(PATHCI)/util/hooks/post_job.sh

setup-docker:
	bash $(PATHCI)/util/hooks/pre_job.sh
	bash $(PATHCI)/setup/install-docker.sh
	bash $(PATHCI)/util/hooks/post_job.sh

setup-trivy:
	bash $(PATHCI)/util/hooks/pre_job.sh
	bash $(PATHCI)/setup/install-trivy.sh
	bash $(PATHCI)/util/hooks/post_job.sh

setup-nvm:
	bash $(PATHCI)/util/hooks/pre_job.sh
	bash $(PATHCI)/setup/install-nvm.sh
	bash $(PATHCI)/util/hooks/post_job.sh

setup-git:
	bash $(PATHCI)/util/hooks/pre_job.sh
	bash $(PATHCI)/setup/setup-git.sh
	bash $(PATHCI)/util/hooks/post_job.sh

setup-permissions:
	bash $(PATHCI)/util/hooks/pre_job.sh
	bash $(PATHCI)/setup/permissions.sh
	bash $(PATHCI)/util/hooks/post_job.sh

util-git-restore-tags:
	bash $(PATHCI)/util/hooks/pre_job.sh
	bash $(PATHCI)/util/git/restore-tags.sh
	bash $(PATHCI)/util/hooks/post_job.sh
