FROM jenkins/jenkins:lts-alpine
USER root
RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    curl \
    openjdk11-jdk
COPY jenkins-setup.sh /usr/share/jenkins/jenkins-setup.sh
RUN chmod +x /usr/share/jenkins/*.sh
USER jenkins
EXPOSE 8080 50000
ENTRYPOINT ["/bin/sh", "-c", "/usr/local/bin/jenkins.sh & /usr/share/jenkins/jenkins-setup.sh && tail -f /dev/null"]