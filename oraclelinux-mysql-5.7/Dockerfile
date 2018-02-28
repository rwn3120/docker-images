FROM radowan/oraclelinux-java-8:latest

LABEL maintainer="radowan <radek.strejc@gmail.com>"

# Download mysql
RUN wget --progress=bar:force https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-community-server-5.7.21-1.el7.x86_64.rpm -O /tmp/mysql-server.rpm
RUN wget --progress=bar:force https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-community-client-5.7.21-1.el7.x86_64.rpm -O /tmp/mysql-client.rpm
RUN wget --progress=bar:force https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-community-common-5.7.21-1.el7.x86_64.rpm -O /tmp/mysql-common.rpm
RUN wget --progress=bar:force https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-community-libs-5.7.21-1.el7.x86_64.rpm -O /tmp/mysql-community-libs.rpm

# Install deps
RUN yum -y install libaio numactl-libs net-tools

# Install mysql
RUN rpm -i /tmp/mysql*.rpm

# Clean up
RUN rm -f /tmp/*.rpm

# Add start script
ADD service-mysql-start.sh /usr/bin/service-mysql-start
ADD service-mysql-stop.sh /usr/bin/service-mysql-stop
ADD entrypoint.sh /usr/bin/entrypoint-mysql
RUN chmod +x /usr/bin/*mysql*

# expose ports
EXPOSE 3306

# Set bash as default command
ENTRYPOINT ["entrypoint-mysql"]
CMD ["mysql"]
