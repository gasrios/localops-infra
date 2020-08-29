REPOSITORY ?= docker.localhost
UNIX_TIME := $(shell date +%s%N)
VERSION ?= $(UNIX_TIME)
ENVIRONMENT ?= local

.PHONY: all clean publish deploy delete-local

default: clean build build-config publish

all: default deploy

clean:
	./gradlew clean

build: build/libs/hello.jar
build/libs/hello.jar: $(shell find src/main/java -type f)
	./gradlew bootRepackage

build-config: build/$(ENVIRONMENT).yaml
build/$(ENVIRONMENT).yaml: templates/$(ENVIRONMENT).yaml
	mkdir -p build
	sed \
		's/image: REPOSITORY\/hello:.*/image: $(REPOSITORY)\/hello:$(VERSION)/' \
		templates/$(ENVIRONMENT).yaml > build/$(ENVIRONMENT).yaml

publish:
	docker build -t $(REPOSITORY)/hello:$(VERSION) .
	docker push $(REPOSITORY)/hello

deploy:
	kubectl config use-context $(ENVIRONMENT)
	kubectl apply -f build/$(ENVIRONMENT).yaml

undeploy:
	kubectl config use-context $(ENVIRONMENT)
	kubectl delete --ignore-not-found service hello-service
	kubectl delete --ignore-not-found deployment hello-deployment
