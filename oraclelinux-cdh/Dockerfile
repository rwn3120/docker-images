FROM radowan/oraclelinux-mysql:5.7

LABEL maintainer="radowan <radek.strejc@gmail.com>"

# Args
ARG HADOOP_GROUP
ARG HADOOP_USER
ARG CDH_MAJOR_VERSION
ARG CDH_MINOR_VERSION
ARG JACKSON_DATABIND_VERSION
ARG PARQUET_HADOOP_VERSION
ARG JACKSON_DATABIND_VERSION
ARG AWS_SDK_BUNDLE
ARG HADOOP_VERSION
ARG SPARK_VERSION
ARG HIVE_VERSION

# Set env
ENV CDH_VERSION="${CDH_MAJOR_VERSION}.${CDH_MINOR_VERSION}" \
    USER="${HADOOP_USER}" \
    HADOOP_USER_HOME="/home/${HADOOP_USER}" \
    HADOOP_USER="${HADOOP_USER}" \
    HADOOP_GROUP="${HADOOP_GROUP}" \
    HADOOP_VERSION="${HADOOP_VERSION}" \
    SPARK_VERSION="${SPARK_VERSION}" \
    HIVE_VERSION="${HIVE_VERSION}"
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
            "https://repository.cloudera.com/content/repositories/releases/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}-cdh${CDH_VERSION}/hadoop-aws-${HADOOP_VERSION}-cdh${CDH_VERSION}.jar" \
            -P "${HADOOP_HOME}/share/hadoop/yarn/" &&\
    wget --progress=bar:force \
            "http://central.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_BUNDLE}/aws-java-sdk-bundle-${AWS_SDK_BUNDLE}.jar" \
            -P "${HADOOP_HOME}/share/hadoop/yarn/" &&\
    wget --progress=bar:force \
            "https://repository.cloudera.com/artifactory/libs-release-local/com/twitter/parquet-hadoop/${PARQUET_HADOOP_VERSION}-cdh${CDH_VERSION}/parquet-hadoop-${PARQUET_HADOOP_VERSION}-cdh${CDH_VERSION}.jar" \
            -P "${HADOOP_HOME}/share/hadoop/yarn/"

# Setup hadoop
ADD conf/hadoop/core-site.xml \
    conf/hadoop/yarn-site.xml \
    conf/hadoop/hdfs-site.xml \
    conf/hadoop/mapred-site.xml \
    conf/hadoop/hadoop-env.sh \
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

# Format hdfs, prepare env
RUN hdfs namenode -format &&\
    ssh-setup &&\
    sudo sed -i 's/#PermitEmptyPasswords .*/PermitEmptyPasswords yes/' /etc/ssh/sshd_config &&\
    sudo passwd -d "${HADOOP_USER}" &&\
    find "${HADOOP_USER_HOME}" -type d -exec chmod 777 {} \;

# Add scripts
ADD scripts/hadoop-cluster-start \
    scripts/hadoop-cluster-stop \
    scripts/entrypoint \
    /usr/bin/

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
ENTRYPOINT ["/usr/bin/entrypoint"]

# Set default command
CMD ["spark-shell"]
