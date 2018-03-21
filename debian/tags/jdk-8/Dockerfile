FROM radowan/debian:base
LABEL maintainer="radowan <radek.strejc@gmail.com>"

ARG JDK_DOWNLOAD_LINK
ARG JAVA_HOME

# update PATH
ENV PATH="${PATH}":"${JAVA_HOME}/bin"
ENV JAVA_HOME="${JAVA_HOME}"

# download java, update alternatives
RUN mkdir -p "${JAVA_HOME}" &&\
    \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "${JDK_DOWNLOAD_LINK}" -O "jdk.tar.gz" &&\
    tar xzf "jdk.tar.gz" --directory "${JAVA_HOME}" --strip 1 &&\
    rm -f "jdk.tar.gz" &&\
    \
    update-alternatives --install /usr/bin/java    java    "${JAVA_HOME}/bin/java"        100 &&\
    update-alternatives --install /usr/bin/javac   javac   "${JAVA_HOME}/bin/javac"       100 &&\
    update-alternatives --install /usr/bin/keytool keytool "${JAVA_HOME}/jre/bin/keytool" 100

# default command
CMD ["/bin/bash"]
