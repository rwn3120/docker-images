FROM debian:stretch

RUN apt-get update

RUN \
  apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  apt-get update && \
  apt-get install -y --allow-unauthenticated oracle-java8-installer oracle-java8-set-default curl wget iputils-ping telnet mc jq procps python file python-pip && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

RUN pip install gTTS

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

CMD ["/bin/bash"]
