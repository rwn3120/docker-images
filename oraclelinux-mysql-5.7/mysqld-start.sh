#!/bin/bash -e

SERVICE="mysqld"
PID_FILE="/var/run/${SERVICE}/${SERVICE}.pid"

if [ -e "${PID_FILE}" ]; then
  echo "${SERVICE} is already running (pidfile ${PID_FILE})"
  exit 0
fi

echo -n "Starting ${SERVICE}..."
nohup mysqld \
  --user="${MYSQL_USER}" \
  --explicit_defaults_for_timestamp \
  --verbose \
  --log-error-verbosity=3 &>${SERVICE}.nohup &
while ! mysqladmin ping --silent &>/dev/null; do
  echo -n "."
  sleep 1
done
PID=$(cat "${PID_FILE}")
echo "done [${PID}]"