FROM oraclelinux:latest

LABEL maintainer="radowan <radek.strejc@gmail.com>"

# Install system utils, download & install java, clean up
ARG JAVA_RPM_URL="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
RUN yum -y upgrade &&\
    yum -y install \
        sudo wget vim mc telnet rsync &&\
    groupadd sudo &&\
    \
    wget \
        --no-check-certificate \
        --no-cookies \
        --header "Cookie: oraclelicense=accept-securebackup-cookie" \
        "${JAVA_RPM_URL}" &&\
    rpm -ivh *.rpm &&\
    rm -f *.rpm &&\
    yum clean all &&\
    \
    ssh-keygen -A

# Add start & stop scripts
ADD "sshd-start.sh" "/usr/bin/sshd-start"
ADD "sshd-stop.sh" "/usr/bin/sshd-stop"
ADD "ssh-setup.sh" "/usr/bin/ssh-setup"

# Expose ports
EXPOSE 22

# Set JAVA_HOME
RUN export JAVA_HOME="/usr/bin"
