VERSION=$(shell git describe)
IMAGE:=dockerhub.motiondsp.com/docker-yum-repo

build:
	docker build -t $(IMAGE):$(VERSION) .

push:
	docker push $(IMAGE):$(VERSION)

