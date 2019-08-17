REPOSITORY ?= docker.localhost
UNIX_TIME := $(shell date +%s%N)
VERSION ?= $(UNIX_TIME)
ENVIRONMENT ?= local

.PHONY: all clean publish deploy

all: clean build publish deploy

clean:
	./gradlew clean

build: build/libs/hello.jar
build/libs/hello.jar: $(shell find src/main/java)
	./gradlew bootRepackage
	sed \
		's/image: REPOSITORY\/ref\/hello:.*/image: $(REPOSITORY)\/ref\/hello:$(VERSION)/' \
		templates/$(ENVIRONMENT).yaml > build/$(ENVIRONMENT).yaml

publish:
	docker build -t $(REPOSITORY)/ref/hello:$(VERSION) .
	docker push $(REPOSITORY)/ref/hello

deploy:
	kubectl config use-context $(ENVIRONMENT)
	kubectl apply -f build/$(ENVIRONMENT).yaml
