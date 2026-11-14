.PHONY: setup start build up rebuild

LOCAL_COMPOSE := docker compose -f docker-compose.yml -f docker-compose.local.yml

setup:
	@echo 'PSPulse and Afterglow are fetched during the Docker build.'

build:
	$(LOCAL_COMPOSE) build

up: build
	$(LOCAL_COMPOSE) up -d --no-build

start: up

# Fresh upstream data: --no-cache re-clones PSPulse/Afterglow, --pull refreshes the base images.
rebuild:
	$(LOCAL_COMPOSE) build --no-cache --pull
	$(LOCAL_COMPOSE) up -d --no-build
