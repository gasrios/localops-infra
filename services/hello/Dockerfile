FROM openjdk:13-alpine

RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

ENTRYPOINT ["java", "-jar"]

COPY build/libs/hello.jar /opt

CMD ["/opt/hello.jar"]
