REPOSITORY ?= docker.localhost
UNIX_TIME := $(shell date +%s%N)
VERSION ?= $(UNIX_TIME)
ENVIRONMENT ?= microk8s

.PHONY: all clean deploy undeploy

all: docker deploy

docker: clean build publish

clean:
	./gradlew clean

build: build/libs/ipify.jar
build/libs/ipify.jar: $(shell find src/main/java -type f)
	./gradlew bootRepackage

publish: build/$(ENVIRONMENT).yaml
build/$(ENVIRONMENT).yaml: templates/$(ENVIRONMENT).yaml $(shell find src/main/java -type f)
	mkdir -p build
	sed \
		's/image: REPOSITORY\/ipify:.*/image: $(REPOSITORY)\/ipify:$(VERSION)/' \
		templates/$(ENVIRONMENT).yaml > build/$(ENVIRONMENT).yaml
	docker build -t $(REPOSITORY)/ipify:$(VERSION) .
	docker push $(REPOSITORY)/ipify

deploy:
	kubectl config use-context $(ENVIRONMENT)
	kubectl apply -f build/$(ENVIRONMENT).yaml

undeploy:
	kubectl config use-context $(ENVIRONMENT)
	kubectl delete --ignore-not-found service ipify-service
	kubectl delete --ignore-not-found deployment ipify-deployment
