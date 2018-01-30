IMAGE_NAME ?= jmcclell/sbt-dev-docker
IMAGE_VERSION ?= latest
CONTAINER_WORKDIR ?= /workspace

.PHONY: build run

build: Dockerfile
	docker build -t $(IMAGE_NAME):$(IMAGE_VERSION) .

run:
	docker run -it --rm \
		-w $(CONTAINER_WORKDIR) \
		-v $(CURDIR):$(CONTAINER_WORKDIR) \
		-v $(HOME)/.sbt:/root/.sbt \
		-v $(HOME)/.ivy2:/root/.ivy2 \
		-v $(HOME)/.coursier:/root/.coursier \
		$(IMAGE_NAME):$(IMAGE_VERSION) $(cmd)

default: build
