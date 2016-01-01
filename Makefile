default: build

.PHONY: build
build:
	docker build -t "sebastianmarkow/docker-caddy:latest" .
