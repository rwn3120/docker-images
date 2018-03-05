#!/bin/bash -e

sudo /usr/bin/sshd-start

echo "Booting up hadoop cluster..."
echo -en "     ... "
"${HADOOP_HOME}/sbin/hadoop-daemon.sh" start namenode
echo -en "     ... "
"${HADOOP_HOME}/sbin/hadoop-daemon.sh" start secondarynamenode
echo -en "     ... "
"${HADOOP_HOME}/sbin/hadoop-daemon.sh" start datanode
echo -en "     ... "
"${HADOOP_HOME}/sbin/yarn-daemon.sh" start resourcemanager
echo -en "     ... "
"${HADOOP_HOME}/sbin/yarn-daemon.sh" start nodemanager
echo -en "     ... "
"${SPARK_HOME}/sbin/start-all.sh"
echo "     ...done"

