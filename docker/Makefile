PROJECT_DIR = $(shell dirname $(shell pwd))
TIDY=2>/dev/null ; true

tutorial : 
	@echo "\033[0;95 TLDR: run \"make kickstart\"\033[0m \n \
	a bit longer, for docker you need to build the image, \n \
	then launch a container, \n \
	then attach a terminal to this running container \n \
	checkout the makefile for a list of commands"

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

.PHONY: tutorial exec run build down clean ls kickstart re
