PROJECT_DIR = $(shell dirname $(shell pwd))
TIDY=2>/dev/null ; true

tutorial : 
	@echo "\033[0;95mTLDR: run \"make kickstart\"\033[0m \n\
	for more info: \"make help\" or read the makefile its self"

exec : 
	@docker exec -it apero-gleam-container /bin/zsh
	
run :
	@docker run --name apero-gleam-container -td -p 8000:8000 -v $(PROJECT_DIR):/apero-gleam apero-gleam-image tail -f /dev/null

build :
	@docker build -t apero-gleam-image .

down :
	@docker container stop --time=0 apero-gleam-container $(TIDY)

clean : down
	@docker container rm -f apero-gleam-container $(TIDY)
	@docker image rm -f apero-gleam-image         $(TIDY)

ls : 
	@docker image ls -a
	@docker container ls -a

ip :
	@docker ps -q | xargs -I{} docker inspect -f '{{.Name}} {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' {}

kickstart: build run exec

re : clean kickstart

help:
	@echo "To avoid the mess that is dependancies and os variance, \n\
	develop inside a docker container. \n\
	\n\
	Setting up a container is a 2 step process: \n\
	\n\
	'make build' build the image folliwing the dockerfile as a recipie \n\
	\n\
	'make run'   luanch a new container using this newly built image and \n\
	             the project repo as a bind mount ie changes made in the \n\
	             container are reflected on your system, also forward \n\
	             port 8000 externally, so we can see the hosted site. \n\
	\n\
	Great you have a container running in detached mode \n\
	\n\
	'make ls'    to list the running containers and images, notice it's \n\
	             exicuteing tail -f /dev/nul, a never ending process.\n\
	\n\
	'make ip'    to see the ipadress of your container \n\
	\n
	form here if you wish to develop inside vscode, you can launch a fresh \n\
	instance and attach to this container, or: \n\
	\n\
	'make exec'  to to run a command inside the container, /bin/zsh in this case, \n\
	             you now have access to a terminal inside the container \n\
	\n\
	'make down'  to gently stop your container \n\
	
	'make clean' to whipe everything docker, project files remain untoched."

.PHONY: tutorial exec run build down clean ls kickstart re
