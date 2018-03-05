FROM radowan/oraclelinux-mysql-5.7:latest

LABEL maintainer="radowan <radek.strejc@gmail.com>"

# Args
ARG HADOOP_GROUP="hadoop"
ARG HADOOP_USER="${HADOOP_GROUP}"
ARG CDH_MAJOR_VERSION=5
ARG CDH_MINOR_VERSION=13.1
# for JACKSON_DATABIND_VERSION see https://mvnrepository.com/artifact/com.cloudera.api/cloudera-manager-api/5.13.1
ARG JACKSON_DATABIND_VERSION=2.1.0
# or PARQUET_HADOOP_VERSION see https://repository.cloudera.com/artifactory/libs-release-local/com/twitter/parquet-hadoop/1.5.0-cdh5.13.1/
ARG PARQUET_HADOOP_VERSION=1.5.0
# for package versions see https://www.cloudera.com/documentation/enterprise/release-notes/topics/cdh_vd_cdh_package_tarball_513.html#cm_vd_cdh_package_tarball_513
ARG HADOOP_VERSION=2.6.0
ARG SPARK_VERSION=1.6.0
ARG HIVE_VERSION=1.1.0

# Set env
ENV CDH_VERSION="${CDH_MAJOR_VERSION}.${CDH_MINOR_VERSION}" \
    USER="${HADOOP_USER}" \
    HADOOP_USER_HOME="/home/${HADOOP_USER}"
ENV CDH_HOME="${HADOOP_USER_HOME}/cdh${CDH_VERSION}"
ENV HADOOP_HOME="${CDH_HOME}/hadoop-${HADOOP_VERSION}" \
    SPARK_HOME="${CDH_HOME}/spark-${SPARK_VERSION}" \
    HIVE_HOME="${CDH_HOME}/hive-${HIVE_VERSION}" \
    HDFS_HOME="${HADOOP_USER_HOME}/hdfs" \
    YARN_LOGS="${HADOOP_USER_HOME}/logs/yarn" \
    \
    HADOOP_TMP_DIR="/var/hadoop-${HADOOP_VERSION}/tmp" \
    \
    HADOOP_DOWNLOAD_LINK="http://archive.cloudera.com/cdh${CDH_MAJOR_VERSION}/cdh/${CDH_MAJOR_VERSION}/hadoop-${HADOOP_VERSION}-cdh${CDH_VERSION}.tar.gz" \
    SPARK_DOWNLOAD_LINK="http://archive.cloudera.com/cdh${CDH_MAJOR_VERSION}/cdh/${CDH_MAJOR_VERSION}/spark-${SPARK_VERSION}-cdh${CDH_VERSION}.tar.gz" \
    HIVE_DOWNLOAD_LINK="http://archive.cloudera.com/cdh${CDH_MAJOR_VERSION}/cdh/${CDH_MAJOR_VERSION}/hive-${HIVE_VERSION}-cdh${CDH_VERSION}.tar.gz"

# Set PATH
ENV PATH="${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${SPARK_HOME}/bin:${HIVE_HOME}/bin"

# CREATE hadoop USER (with password hadoop), WE DO TRUST a lot TO HADOOP USER ;)
RUN groupadd "${HADOOP_GROUP}" &&\
    useradd --create-home -d "${HADOOP_USER_HOME}" --shell /bin/bash -g "${HADOOP_GROUP}" "${HADOOP_USER}" &&\
    echo "${HADOOP_USER}        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# Set user
USER "${HADOOP_USER}:${HADOOP_GROUP}"
WORKDIR "${HADOOP_USER_HOME}"

# Make Data and Log Directories
RUN mkdir -p \
      "${CDH_HOME}" "${HADOOP_HOME}" "${SPARK_HOME}" "${HIVE_HOME}" \
      "${HDFS_HOME}/namenode" "${HDFS_HOME}/datanode" \
      "${HADOOP_HOME}/tmp" "${HADOOP_HOME}/libs"

# Download and install hadoop, spark, hive, ...
RUN wget --progress=bar:force "${HADOOP_DOWNLOAD_LINK}" -O "archive.tar.gz" &&\
    tar xzf "archive.tar.gz" --directory "${HADOOP_HOME}" --strip 1 &&\
    \
    wget --progress=bar:force "${SPARK_DOWNLOAD_LINK}" -O "archive.tar.gz" &&\
    tar xzf "archive.tar.gz" --directory "${SPARK_HOME}" --strip 1 &&\
    \
    wget --progress=bar:force "${HIVE_DOWNLOAD_LINK}" -O "archive.tar.gz" &&\
    tar xzf "archive.tar.gz" --directory "${HIVE_HOME}" --strip 1 &&\
    rm -f "archive.tar.gz"
ENV JACKSON_DATABIND_VERSION=2.4.4
# Download libs
RUN cp "${SPARK_HOME}/lib/spark-${SPARK_VERSION}-cdh${CDH_VERSION}-yarn-shuffle.jar" "${HADOOP_HOME}/share/hadoop/yarn/" &&\
    wget --progress=bar:force \
        "http://central.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/${JACKSON_DATABIND_VERSION}/jackson-databind-${JACKSON_DATABIND_VERSION}.jar" \
        -P "${HADOOP_HOME}/share/hadoop/yarn/" &&\
    wget --progress=bar:force \
            "http://central.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/${JACKSON_DATABIND_VERSION}/jackson-core-${JACKSON_DATABIND_VERSION}.jar" \
            -P "${HADOOP_HOME}/share/hadoop/yarn/" &&\
    wget --progress=bar:force \
            "http://central.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/${JACKSON_DATABIND_VERSION}/jackson-annotations-${JACKSON_DATABIND_VERSION}.jar" \
            -P "${HADOOP_HOME}/share/hadoop/yarn/" &&\
    wget --progress=bar:force \
            "https://repository.cloudera.com/artifactory/libs-release-local/com/twitter/parquet-hadoop/${PARQUET_HADOOP_VERSION}-cdh${CDH_VERSION}/parquet-hadoop-${PARQUET_HADOOP_VERSION}-cdh${CDH_VERSION}.jar" \
            -P "${HADOOP_HOME}/share/hadoop/yarn/"

# Setup hadoop
ADD hadoop/core-site.xml \
    hadoop/yarn-site.xml \
    hadoop/hdfs-site.xml \
    hadoop/mapred-site.xml \
    hadoop/hadoop-env.sh \
    "${HADOOP_HOME}/etc/hadoop"/

# Setup spark
RUN cp "${SPARK_HOME}/conf/slaves.template" "${SPARK_HOME}/conf/slaves" &&\
    cp "${SPARK_HOME}/conf/spark-defaults.conf.template" "${SPARK_HOME}/conf/spark-defaults.conf" &&\
    echo 'spark.dynamicAllocation.enabled true' >> "${SPARK_HOME}/conf/spark-defaults.conf" &&\
    echo 'spark.shuffle.service.enabled true' >> "${SPARK_HOME}/conf/spark-defaults.conf" &&\
    echo 'spark.executor.instances 0' >> "${SPARK_HOME}/conf/spark-defaults.conf" &&\
    cp "${SPARK_HOME}/conf/spark-env.sh.template" "${SPARK_HOME}/conf/spark-env.sh" &&\
    echo 'export JAVA_HOME=$(readlink -f $(which java) | sed "s/\/bin\/.*//")' > "${SPARK_HOME}/conf/spark-env.sh" &&\
    echo "export HADOOP_HOME=${HADOOP_HOME}" >> "${SPARK_HOME}/conf/spark-env.sh" &&\
    echo 'export SPARK_DIST_CLASSPATH=`"${HADOOP_HOME}/bin/hadoop" classpath`'  >> "${SPARK_HOME}/conf/spark-env.sh" &&\
    echo "export SPARK_MASTER_IP=hadoop-master" >> "${SPARK_HOME}/conf/spark-env.sh" &&\
    echo "export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop" >> "${SPARK_HOME}/conf/spark-env.sh"

# Link configurations to etc
RUN sudo mkdir -p /etc/{hadoop,spark,hive} &&\
    sudo ln -s "${CDH_HOME}" /opt &&\
    sudo ln -s "${HADOOP_HOME}/etc/hadoop" /etc/hadoop &&\
    sudo ln -s "${SPARK_HOME}/conf" /etc/spark &&\
    sudo ln -s "${HIVE_HOME}/conf" /etc/hive &&\
    sudo sed -i 's/#PermitEmptyPasswords .*/PermitEmptyPasswords yes/' /etc/ssh/sshd_config &&\
    sudo passwd -d "${HADOOP_USER}"

# Format hdfs
RUN hdfs namenode -format

# Add start & stop scripts
ADD hadoop-cluster-start.sh /usr/bin/hadoop-cluster-start
ADD hadoop-cluster-stop.sh /usr/bin/hadoop-cluster-stop

# Expose ports
# HDFS Namenode (dfs.http.address, dfs.https.address)
EXPOSE 50070 50470
# HDFS Datanodes (dfs.datanode.http.address, dfs.datanode.https.address, dfs.datanode.address, dfs.datanode.ipc.address)
EXPOSE 50075 50475 50010 50020
# HDFS SecondaryNamenode (dfs.secondary.http.address)
EXPOSE 50090
# HDFS NameNodeMetadataService
EXPOSE 8020 9000 54310
# Backup/Checkpoint node (dfs.backup.http.address)
EXPOSE 50105
# MR Jobracker WebUI (mapred.job.tracker.http.address)
EXPOSE 50030
# MR Jobracker (Embedded in URI specified by mapred.job.tracker)
EXPOSE 8021
# Task­Tracker Web UI and Shuffle (mapred.task.tracker.http.address)
EXPOSE 50060
# MR HistorServer WebUI  (mapreduce.history.server.http.address)
EXPOSE 51111
# ResourceManager
EXPOSE 8030 8031 8032 8088 8090
# Spark
EXPOSE 8080 8081 7077 8042 6066 4040 18080 7337

# Set entrypoint
COPY entrypoint.sh /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]

# Set default command
CMD ["spark-shell"]