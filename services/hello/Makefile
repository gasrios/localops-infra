REPOSITORY ?= docker.localhost
UNIX_TIME := $(shell date +%s%N)
VERSION ?= $(UNIX_TIME)
ENVIRONMENT ?= local

.PHONY: all clean publish deploy delete-local

all: clean build publish deploy

clean:
	./gradlew clean

build: build/libs/hello.jar
build/libs/hello.jar: $(shell find src/main/java)
	./gradlew bootRepackage
	sed \
		's/image: REPOSITORY\/hello:.*/image: $(REPOSITORY)\/hello:$(VERSION)/' \
		templates/$(ENVIRONMENT).yaml > build/$(ENVIRONMENT).yaml

publish:
	docker build -t $(REPOSITORY)/hello:$(VERSION) .
	docker push $(REPOSITORY)/hello

deploy:
	kubectl config use-context $(ENVIRONMENT)
	kubectl apply -f build/$(ENVIRONMENT).yaml

delete-local:
	[ $(ENVIRONMENT) = local ] && kubectl delete --ignore-not-found service hello-service
	[ $(ENVIRONMENT) = local ] && kubectl delete --ignore-not-found deployment hello-deployment
