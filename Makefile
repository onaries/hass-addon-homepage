.PHONY: up down logs build push tag clean sync init

IMAGE := ksw8954/homepage-dashboard
VERSION := $(shell grep '^version:' homepage/config.yaml | sed 's/version: *"\(.*\)"/\1/')

init:
	git config core.hooksPath .githooks
	@echo "Git hooks configured (.githooks/)"

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

build:
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest homepage/

push:
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

tag:
	@echo "Tagging v$(VERSION) ..."
	git tag "v$(VERSION)" && git push origin "v$(VERSION)"

clean:
	docker compose down -v --rmi local
	docker image prune -f

sync:
	rsync -avz --exclude '.git' --exclude 'node_modules' ./ oracle2:~/projects/homepage-server/
