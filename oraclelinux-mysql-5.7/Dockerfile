FROM radowan/oraclelinux-java-8:latest

LABEL maintainer="radowan <radek.strejc@gmail.com>"

ENV MYSQL_USER="mysql"

# Install & initialize mysql
RUN wget --progress=bar:force "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-community-server-5.7.21-1.el7.x86_64.rpm" -O "mysql-server.rpm" &&\
    wget --progress=bar:force "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-community-client-5.7.21-1.el7.x86_64.rpm" -O "mysql-client.rpm" &&\
    wget --progress=bar:force "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-community-common-5.7.21-1.el7.x86_64.rpm" -O "mysql-common.rpm" &&\
    wget --progress=bar:force "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-community-libs-5.7.21-1.el7.x86_64.rpm" -O "mysql-community-libs.rpm" &&\
    \
    yum -y install \
      libaio numactl-libs net-tools &&\
    \
    rpm -i *.rpm &&\
    \
    rm -f *.rpm  &&\
    yum clean all &&\
    \
    mysqld \
      --user="${MYSQL_USER}" \
      --verbose \
      --log-error-verbosity=3 \
      --initialize-insecure

# Add start & stop scripts
ADD mysqld-start.sh /usr/bin/mysqld-start
ADD mysqld-stop.sh /usr/bin/mysqld-stop

# expose ports
EXPOSE 3306

# Set entrypoint
ADD entrypoint.sh /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]

# Set default command
CMD ["mysql"]