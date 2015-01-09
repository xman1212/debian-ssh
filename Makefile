all: test

CONTAINER_NAME=debian-ssh:latest

killall: .FORCE
	docker kill $$(docker ps | sed -r -n '/^[^ ]+ +$(CONTAINER_NAME) / {s/ .*$$//;p}')

build:
	docker build -t $(CONTAINER_NAME) .

test: build .FORCE
	docker run -d -p 2222:22 -e SSH_KEY="$$(cat ~/.ssh/id_rsa.pub)" $(CONTAINER_NAME)
	while ! ssh root@localhost -p 2222 -o "StrictHostKeyChecking=no" env; do sleep 0.1; done
	docker kill $$(docker ps -ql)

debug-ssh: build .FORCE
	docker run -p 2222:22 -e SSH_KEY="$$(cat ~/.ssh/id_rsa.pub)" $(CONTAINER_NAME)

debug-connect: .FORCE
	ssh root@localhost -p 2222 -o "StrictHostKeyChecking=no" env

.FORCE:
