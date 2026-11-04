.PHONY: setup start build up

LOCAL_COMPOSE := docker compose -f docker-compose.yml -f docker-compose.local.yml

setup:
	@echo 'PSPulse and Afterglow are fetched during the Docker build.'

build:
	$(LOCAL_COMPOSE) build

up: build
	$(LOCAL_COMPOSE) up -d --no-build

start: up
