.DEFAULT_GOAL := help
SHELL := /bin/bash

help:
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

up: ## start containers
	docker-compose -f .docker/docker-compose.yaml up -d
down: ## stop containers
	docker-compose -f .docker/docker-compose.yaml down
build: ## build containers
	docker-compose -f .docker/docker-compose.yaml build
ps: ## list containers
	docker-compose -f .docker/docker-compose.yaml ps
php: ## enter in node container
	docker exec -it php /bin/bash