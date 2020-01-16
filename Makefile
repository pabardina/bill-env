USERNAME = bill
CONTAINER_NAME = dev-${USERNAME}-env
IMAGE_NAME = ${USERNAME}-env
WORKSPACE=$(shell pwd)
STAMPS_DIR=$(WORKSPACE)/.stamps

$(STAMPS_DIR):
	@mkdir $@

help:
	@echo ''
	@echo 'Usage: make [TARGET] [EXTRA_ARGUMENTS]'
	@echo 'Targets:'
	@echo '  build    	build docker only once'
	@echo '  rebuild  	rebuild docker image'
	@echo '  run	  	build-start-shell'
	@echo '  shell  	launch a shell into the container'
	@echo '  exec cmd=ls	launch a cmd into the container'
	@echo '  clean		clean everything'
	@echo ''


build: $(STAMPS_DIR) $(STAMPS_DIR)/build
$(STAMPS_DIR)/build:
	$(info Make: Build Docker Image ${IMAGE_NAME} )
	docker build --build-arg USERNAME=${USERNAME} -t ${IMAGE_NAME} .
	@touch $@

rebuild:
	$(info Make: Build Docker Image ${IMAGE_NAME} )
	docker build --build-arg USERNAME=${USERNAME} -t ${IMAGE_NAME} .


init: $(STAMPS_DIR) $(STAMPS_DIR)/init
$(STAMPS_DIR)/init:
	$(info Make: Create folder with git repos to share with container )
	# create repo on host to share with container, and create go/work folder inside
	-mkdir -p ~/my-git-repos/go/work
	@touch $@

start: init build
	-@docker create --name=${CONTAINER_NAME} -v /var/run/docker.sock:/var/run/docker.sock -v ~/my-git-repos:/home/${USERNAME}/my-git-repos  -it ${IMAGE_NAME} 2>/dev/null
	-@docker start ${CONTAINER_NAME} 2>/dev/null

run: start shell

shell: 
	-@docker exec -it ${CONTAINER_NAME} zsh 2>/dev/null || make run

exec:
	-@docker exec -it ${CONTAINER_NAME} "$(cmd)"


stop:
	-@docker stop ${CONTAINER_NAME}

clean: stop
	-@docker rm -f ${CONTAINER_NAME}
	-@docker rmi -f ${IMAGE_NAME}
	-@rm -rf .stamps
