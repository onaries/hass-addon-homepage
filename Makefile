.PHONY: up down logs build push tag clean sync

IMAGE := ksw8954/homepage-dashboard
VERSION := $(shell grep '^version:' config.yaml | sed 's/version: *"\(.*\)"/\1/')

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

build:
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

push:
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

tag:
	@read -p "Version (current: $(VERSION)): " v; \
	git tag "v$$v" && git push origin "v$$v"

clean:
	docker compose down -v --rmi local
	docker image prune -f

sync:
	rsync -avz --exclude '.git' --exclude 'node_modules' ./ oracle2:~/projects/homepage-server/
