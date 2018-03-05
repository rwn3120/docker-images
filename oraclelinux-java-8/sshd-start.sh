#!/bin/bash -e

SERVICE="sshd"
PID_FILE="/var/run/sshd.pid"

if [ -e "${PID_FILE}" ]; then
  echo "${SERVICE} is already running (pidfile ${PID_FILE})"
  exit 0
fi

echo -n "Starting ${SERVICE}..."
/usr/sbin/sshd

PID=$(cat "${PID_FILE}")
echo "done [${PID}]"