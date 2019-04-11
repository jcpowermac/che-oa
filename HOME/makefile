PROJECTS=/projects
SECRETS_REPO='git@github.com:jcpowermac/secrets'
SECRETS=${PROJECTS}/secrets
OPENSHIFT_SECRETS_REPO='git@github.com:openshift/shared-secrets'
OPENSHIFT_SECRETS=${PROJECTS}/shared-secrets
GITKEY='/projects/git-crypt.key'
LOCAL_GITKEY=${HOME}/git-crypt.key
CLUSTER='https://api.starter-us-east-2.openshift.com/'
TOKEN_FILE=${HOME}/service-token.txt

addkey:
	chmod 0600 ${PROJECTS}/id_rsa*
	ssh-add ${PROJECTS}/id_rsa
clone:
	ssh-keyscan -H github.com >> ~/.ssh/known_hosts
	git clone ${SECRETS_REPO} ${SECRETS}
	git clone ${OPENSHIFT_SECRETS_REPO} ${OPENSHIFT_SECRETS}
unlock:
	cd ${SECRETS} ; git-crypt unlock ${GITKEY}
copy:
	make unlock
	cp -r ${SECRETS}/.aws ~
	cp ${SECRETS}/.ssh/* ~/.ssh
	cp ${SECRETS}/openshift-creds.txt ~
	cp ${SECRETS}/redhat.io.txt ~
all:
	make addkey
	make clone
	make copy
token:
	@echo ${CHE_OSO_CLUSTER}
	oc whoami -t
login:
	$(eval TOKEN=$(shell cat ${TOKEN_FILE}))
	oc login --token ${TOKEN} ${CLUSTER}
occp: login
	$(eval PODNAME=$(shell sh -c "oc get pod -l  che.original_name=ws -o jsonpath='{.items[0].metadata.name}'"))
	oc cp ${HOME}/.ssh/id_rsa ${PODNAME}:${PROJECTS} -c dev
	oc cp ${HOME}/.ssh/id_rsa.pub ${PODNAME}:${PROJECTS} -c dev
	oc cp ${LOCAL_GITKEY} ${PODNAME}:${PROJECTS} -c dev
