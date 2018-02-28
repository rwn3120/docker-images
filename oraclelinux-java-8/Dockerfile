FROM oraclelinux:latest

LABEL maintainer="radowan <radek.strejc@gmail.com>"

# Upgrade system
RUN yum -y upgrade

# Install system utils
RUN yum -y install \
    wget vim mc telnet

# Build args
ARG JAVA_RPM_URL="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"
ARG RPM="/tmp/java-linux-x64.rpm"

# Download java
RUN wget \
    --no-check-certificate \
    --no-cookies \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    -O "${RPM}" \
    "${JAVA_RPM_URL}"

# Install java, do cleanup, print java version
RUN rpm -ivh "${RPM}" \
    && rm "${RPM}" \
    && java -version

# Set workspace
WORKDIR "/root"

# Set bash as default command
CMD ["/bin/bash"]
