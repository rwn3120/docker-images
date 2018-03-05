#!/bin/bash -e

sudo /usr/bin/sshd-stop

echo "Stopping hadoop cluster..."
echo -en "     ... "
"${SPARK_HOME}/sbin/stop-all.sh"
echo -en "     ... "
"${HADOOP_HOME}/sbin/yarn-daemon.sh" stop nodemanager
echo -en "     ... "
"${HADOOP_HOME}/sbin/yarn-daemon.sh" stop resourcemanager
echo -en "     ... "
"${HADOOP_HOME}/sbin/hadoop-daemon.sh" stop datanode
echo -en "     ... "
"${HADOOP_HOME}/sbin/hadoop-daemon.sh" stop secondarynamenode
echo -en "     ... "
"${HADOOP_HOME}/sbin/hadoop-daemon.sh" stop namenode
echo "     ...done"

