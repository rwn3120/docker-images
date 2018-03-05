#!/bin/bash -e

/usr/bin/hadoop-cluster-start

if [ "$1" != "spark-shell" ]; then
    LBC="\033[1;34m"
    LCC="\033[1;36m"
    WC="\033[0;37m"
    NO_C="\033[0m"
    echo -e "${LBC}Hi there! Your cluster ${WC}${HOSTNAME}${LBC} is up and running. What now? Try some of these commands:${NO_C}"
    echo -e "${LCC}\tSubmitting spark application:     ${WC}spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode client --executor-memory 1G --num-executors 2 --executor-cores 4 ${SPARK_HOME}/lib/spark-*examples*.jar 100${NO_C}"
    echo -e "${LCC}\tHave some fun with spark-shell:   ${WC}spark-hell${NO_C}"
fi

$@
