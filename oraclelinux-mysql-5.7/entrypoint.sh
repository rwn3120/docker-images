#!/bin/bash

service-mysql-start
if [ "$1" == "mysql" ]; then
    while ! mysqladmin ping --silent; do
        sleep 1
    done
fi
$@
