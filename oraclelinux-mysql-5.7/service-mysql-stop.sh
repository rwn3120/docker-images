#!/bin/bash

MYSQL_PID_FILE="/var/run/mysqld.pid"
MYSQL_PID=$(cat "${MYSQL_PID_FILE}" 2>/dev/null)

if [ "${MYSQL_PID}" == "" ]; then
    echo "MySQL is not running"
    exit 0
fi

echo -n "Stopping MySQL [${MYSQL_PID}]..."
kill "${MYSQL_PID}"
while [ -e "/proc/${MYSQL_PID}" ]; do
    echo -n "."
    sleep .5
done
rm -f "${MYSQL_PID_FILE}"

echo "MySQL stopped"
