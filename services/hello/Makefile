REPOSITORY ?= docker.localhost
UNIX_TIME := $(shell date +%s%N)
VERSION ?= $(UNIX_TIME)
ENVIRONMENT ?= microk8s

.PHONY: pipeline docker clean code-review build build-config test publish deploy undeploy

pipeline: docker publish deploy

docker: code-review build build-config test

clean:
	./gradlew clean

code-review: build/$(ENVIRONMENT)/code-reviewed
build/$(ENVIRONMENT)/code-reviewed: $(shell find src -type f)
	mkdir -p build/$(ENVIRONMENT)
	# TODO add static code review
	touch build/$(ENVIRONMENT)/code-reviewed

build: code-review build/libs/hello.jar
build/libs/hello.jar: $(shell find src -type f)
	rm -f build/$(ENVIRONMENT)/tested
	./gradlew --warning-mode all bootRepackage

build-config: code-review build/$(ENVIRONMENT).yaml
build/$(ENVIRONMENT).yaml: build/libs/hello.jar templates/$(ENVIRONMENT).yaml
	# FIXME No need to build a new image when only the template was updated,
	#       but not doing so will cause a version mismatch. Is there a way to
	#       improve on this?
	docker build -t $(REPOSITORY)/hello:$(VERSION) .
	sed \
		's/image: REPOSITORY\/hello:.*/image: $(REPOSITORY)\/hello:$(VERSION)/' \
		templates/$(ENVIRONMENT).yaml > build/$(ENVIRONMENT).yaml

test: build build-config build/$(ENVIRONMENT)/tested
build/$(ENVIRONMENT)/tested: build/libs/hello.jar
	./gradlew test
	touch build/$(ENVIRONMENT)/tested

publish: test
	docker push $(REPOSITORY)/hello

deploy: publish
	kubectl config use-context $(ENVIRONMENT)
	kubectl apply -f build/$(ENVIRONMENT).yaml

undeploy:
	kubectl config use-context $(ENVIRONMENT)
	kubectl delete --ignore-not-found service hello-service
	kubectl delete --ignore-not-found deployment hello-deployment
