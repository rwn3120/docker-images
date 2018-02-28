#!/bin/bash -e

MYSQL_USER=$(whoami)
MYSQL_DATA_DIR="/tmp/mysql/datadir"
MYSQL_PID_FILE="/var/run/mysqld.pid"

if [ ! -e "${MYSQL_DATA_DIR}" ]; then
    echo "Initializing MySQL"
    mkdir -p "${MYSQL_DATA_DIR}"
    mysqld --no-defaults --user="${MYSQL_USER}" --datadir="${MYSQL_DATA_DIR}" \
    --skip-ssl --explicit-defaults-for-timestamp --open-files-limit=4096 \
    --table_open_cache=400 --gtid-mode=on --enforce-gtid-consistency \
    --server-id=100 --log-error-verbosity=3 \
    --initialize-insecure
    echo "MySQL initialized"
fi

echo "Starting MySQL"
nohup mysqld --no-defaults --user="${MYSQL_USER}" --datadir="${MYSQL_DATA_DIR}" \
    --skip-ssl --explicit-defaults-for-timestamp --open-files-limit=4096 \
    --table_open_cache=400 --gtid-mode=on --enforce-gtid-consistency \
    --server-id=100 &>mysqld.nohup.log &
MYSQL_PID=$!

echo "${MYSQL_PID}" > "${MYSQL_PID_FILE}"
echo "MySQL is running [${MYSQL_PID}]"
