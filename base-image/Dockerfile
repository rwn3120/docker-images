FROM radowan/debian-base:latest

RUN apt-get update

ARG JDK_DOWNLOAD_LINK="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz"
ARG JDK_TGZ="/tmp/jdk.tar.gz"
ENV JAVA_HOME="/opt/oracle-jdk-8"

RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "${JDK_DOWNLOAD_LINK}" -O "${JDK_TGZ}"
RUN mkdir "${JAVA_HOME}"
RUN tar xzf "${JDK_TGZ}" --directory "${JAVA_HOME}" --strip 1
RUN rm -f "${JDK_TGZ}"
RUN update-alternatives --install /usr/bin/java    java    "${JAVA_HOME}/bin/java"        100
RUN update-alternatives --install /usr/bin/javac   javac   "${JAVA_HOME}/bin/javac"       100
RUN update-alternatives --install /usr/bin/keytool keytool "${JAVA_HOME}/jre/bin/keytool" 100
ENV PATH="${PATH}":"${JAVA_HOME}/bin"

RUN apt-get update \
  	&& apt-get install -y curl wget iputils-ping telnet mc jq procps python file python-pip \
	&& apt-get clean

RUN pip install gTTS

CMD ["/bin/bash"]
