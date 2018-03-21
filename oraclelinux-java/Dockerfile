FROM oraclelinux:latest

LABEL maintainer="radowan <radek.strejc@gmail.com>"

# Install system utils, download & install java, clean up
ARG JAVA_RPM_URL
ARG MAVEN_TGZ_URL
ARG MAVEN_HOME

# Environment
ENV PATH="${PATH}:${MAVEN_HOME}/bin"

# Add start & stop scripts
ADD scripts/sshd-start \
    scripts/sshd-stop \
    scripts/ssh-setup \
    /usr/bin/

RUN yum -y upgrade &&\
    yum -y groupinstall "Development tools" &&\
    yum -y install \
        sudo wget vim mc telnet rsync &&\
    \
    groupadd sudo &&\
    sed -i 's/^Defaults\s*secure_path/#Defaults secure_path/' /etc/sudoers &&\
    \
    wget \
        --no-check-certificate \
        --no-cookies \
        --header "Cookie: oraclelicense=accept-securebackup-cookie" \
        "${JAVA_RPM_URL}" &&\
    rpm -ivh *.rpm &&\
    \
    mkdir -p "${MAVEN_HOME}" &&\
    wget ${MAVEN_TGZ_URL} -O maven.tgz &&\
    tar xzvf maven.tgz --strip 1 -C "${MAVEN_HOME}" &&\
    \
    rm -f *.rpm *.tgz &&\
    yum clean all &&\
    \
    ssh-keygen -A &&\
    ssh-setup

# Expose ports
EXPOSE 22

# Set JAVA_HOME
RUN export JAVA_HOME="/usr/bin"
