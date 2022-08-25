CURRENT_DIRECTORY := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
INFRA_DIRECTORY   := $(realpath $(CURRENT_DIRECTORY)/../infra)
SERVICE_NAME      := $(notdir $(CURRENT_DIRECTORY))
CONFIG_SWARM      := docker-compose.swarm.yml
CLUSTER           := swarm
DOTENV            := .env
SERVICES          := frontend
REGISTRY_HOST     := $(shell cat $(INFRA_DIRECTORY)/$(DOTENV) | grep "REGISTRY_HOST" | cut -d "=" -f 2)

# show help
help:
	@echo ''
	@echo 'Usage:'
	@echo ' make [target]'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
	helpMessage = match(lastLine, /^# (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
			printf "\033[36m%-22s\033[0m %s\n", helpCommand,helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

.PHONY: run
# Run dev version with hot module reload
run:
	@yarn serve

.PHONY: lint
# Run linter
lint:
	@yarn lint

.PHONY: update
# Update service in Docker Swarm without downtime
update:
	@set -e; for service in ${SERVICES}; \
		do docker pull ${REGISTRY_HOST}/${SERVICE_NAME}_$${service}:latest \
			&& docker service update \
			--with-registry-auth \
			--image ${REGISTRY_HOST}/${SERVICE_NAME}_$${service}:latest \
			${CLUSTER}_${SERVICE_NAME}_$${service} ; \
	done

.PHONY: deploy
# Deploy to Docker Swarm
deploy:
	@env \
		$$(cat ${INFRA_DIRECTORY}/${DOTENV} | sed '/^[[:blank:]]*#/d;s/#.*//' | xargs) \
		docker stack deploy \
		--orchestrator swarm \
		--with-registry-auth \
		-c "${CURRENT_DIRECTORY}"/${CONFIG_SWARM} \
		${CLUSTER}

.PHONY: undeploy
# Remove service from Docker Swarm
undeploy:
	@set -e; for service in ${SERVICES}; \
		do if docker service ls | grep -q "${CLUSTER}_${SERVICE_NAME}_$${service}" ; \
			then docker service rm ${CLUSTER}_${SERVICE_NAME}_$${service} ; \
			else echo "${CLUSTER}_${SERVICE_NAME}_$${service} is already undeployed" ; \
		fi ; \
	done

.PHONY: push
# Build and push image to registry
push:
	@set -e; for service in ${SERVICES}; \
		do docker build -t ${REGISTRY_HOST}/${SERVICE_NAME}_$${service}:latest \
			-f ${CURRENT_DIRECTORY}/Dockerfile-$${service} ${CURRENT_DIRECTORY}/. \
			&& docker push ${REGISTRY_HOST}/${SERVICE_NAME}_$${service}:latest ; \
	done

.PHONY: push
# Build and push image to registry
pull:
	@set -e; for service in ${SERVICES}; \
		do docker pull ${REGISTRY_HOST}/${SERVICE_NAME}_$${service}:latest ; \
	done

.PHONY: env
# Display environment variables from infra .env
env:
	@echo $$(cat ${INFRA_DIRECTORY}/${DOTENV} | sed '/^[[:blank:]]*#/d;s/#.*//' | xargs)

.PHONY: logs
# Display Docker Swarm container logger
logs:
	@docker logs "$$(docker ps -q -f name=${CLUSTER}_${SERVICE_NAME})"
