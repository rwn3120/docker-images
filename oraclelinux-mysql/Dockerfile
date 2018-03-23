FROM radowan/oraclelinux-java:8

LABEL maintainer="radowan <radek.strejc@gmail.com>"

ARG MYSQL_VERSION
ARG MYSQL_PACKAGE_VERSION
ARG MYSQL_USER

# Environment
ENV MYSQL_USER="${MYSQL_USER}" \
    MYSQL_ADMIN_USER="root"

# Install & initialize mysql
RUN groupadd "${MYSQL_USER}" &&\
    useradd -g "${MYSQL_USER}" "${MYSQL_USER}" &&\
    \
    wget --progress=bar:force "https://cdn.mysql.com/Downloads/MySQL-${MYSQL_VERSION}/mysql-community-server-${MYSQL_PACKAGE_VERSION}.x86_64.rpm" -O "mysql-server.rpm" &&\
    wget --progress=bar:force "https://cdn.mysql.com/Downloads/MySQL-${MYSQL_VERSION}/mysql-community-client-${MYSQL_PACKAGE_VERSION}.x86_64.rpm" -O "mysql-client.rpm" &&\
    wget --progress=bar:force "https://cdn.mysql.com/Downloads/MySQL-${MYSQL_VERSION}/mysql-community-common-${MYSQL_PACKAGE_VERSION}.x86_64.rpm" -O "mysql-common.rpm" &&\
    wget --progress=bar:force "https://cdn.mysql.com/Downloads/MySQL-${MYSQL_VERSION}/mysql-community-libs-${MYSQL_PACKAGE_VERSION}.x86_64.rpm" -O "mysql-community-libs.rpm" &&\
    \
    yum -y install \
      libaio numactl-libs net-tools &&\
    \
    rpm -i *.rpm &&\
    \
    rm -f *.rpm  &&\
    yum clean all

# Add scripts
ADD scripts/mysqld-start \
    scripts/mysqld-stop \
    scripts/entrypoint \
    /usr/bin/

# expose ports
EXPOSE 3306

# Set entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]

# Set default command
CMD ["mysql"]
