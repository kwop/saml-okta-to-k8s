# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

DOCKER_COMPOSE_OPTS=--env-file .env -f docker-compose.yml

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

start: ## Spin up the project
	docker-compose $(DOCKER_COMPOSE_OPTS) up -d

build: ## Build up the project
	docker-compose $(DOCKER_COMPOSE_OPTS) up -d  --build

ps: ## List project containers
	docker-compose $(DOCKER_COMPOSE_OPTS) ps

stop: ## Stop the project
	docker-compose $(DOCKER_COMPOSE_OPTS) stop

destroy: ## Remove all the docker compose artifacts
	docker-compose $(DOCKER_COMPOSE_OPTS) stop
	docker-compose $(DOCKER_COMPOSE_OPTS) rm -f

connect: ## connect to the container
	docker-compose $(DOCKER_COMPOSE_OPTS) run okta-pysaml2-front bash

logs: ## show logs of the container
	docker-compose $(DOCKER_COMPOSE_OPTS) logs okta-pysaml2-front

install-firewalled-test: ## install helm chart firewalled-test
	helm upgrade -n firewalled-test --create-namespace --install firewalled-test helm/firewalled-test

install-okta-test: ## install helm chart okta-sp-test
	helm upgrade -n okta-test --create-namespace --install okta-test helm/okta-test

uninstall-firewalled-test: ## uninstall helm chart firewalled-test
	helm uninstall -n firewalled-test firewalled-test

uninstall-okta-test: ## uninstall helm chart okta-sp-test
	helm uninstall -n okta-test okta-test

push-to-registry: ## manually push container, testing purpose
	docker tag saml-test_okta-pysaml2-front:latest kwop/samltest:latest
	docker push kwop/samltest:latest

boum: ## destroy / remove all containers on the machine
	for f in $$(docker ps -a -q); do docker stop $$f; done
	docker system prune --volumes -f
