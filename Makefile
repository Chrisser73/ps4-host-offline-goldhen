.PHONY: setup start build up

UPSTREAM := https://github.com/psx8/psx8.github.io.git
LOCAL_COMPOSE := docker compose -f docker-compose.yml -f docker-compose.local.yml

setup:
	@if [ -e www ]; then \
		test -d www/.git || { echo 'www exists but is not a Git clone; leaving it untouched.' >&2; exit 1; }; \
		test "$$(git -C www remote get-url origin)" = "$(UPSTREAM)" || { echo 'www has a different origin; leaving it untouched.' >&2; exit 1; }; \
		test "$$(git -C www symbolic-ref --quiet --short HEAD)" = main || { echo 'www is not on main; leaving it untouched.' >&2; exit 1; }; \
		test -z "$$(git -C www status --porcelain)" || { echo 'www has local changes; leaving it untouched.' >&2; exit 1; }; \
		git -C www pull --ff-only origin main; \
	else \
		git clone "$(UPSTREAM)" www; \
	fi

build: setup
	$(LOCAL_COMPOSE) build

up: build
	$(LOCAL_COMPOSE) up -d --no-build

start: up
