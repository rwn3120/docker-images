#!/bin/bash

SERVICE="sshd"
PID_FILE="/var/run/${SERVICE}.pid"
PID=$(cat "${PID_FILE}" 2>/dev/null)

if [ "${PID}" == "" ]; then
  echo "${SERVICE} is not running"
  exit 0
fi

echo -n "Stopping ${SERVICE} [${PID}]..."
kill "${PID}"
while [ -e "/proc/${PID}" ]; do
  echo -n "."
  sleep .5
done
rm -f "${PID_FILE}"
echo "${SERVICE} stopped"
