#!/bin/bash -e

SSH_HOME="${HOME}/.ssh"
CONFIG="${SSH_HOME}/config"
PRIVATE_KEY="${SSH_HOME}/id_rsa"
PUBLIC_KEY="${PRIVATE_KEY}.pub"
AUTHORIZED_KEYS="${SSH_HOME}/authorized_keys"

echo "Generating key ${PRIVATE_KEY}"
ssh-keygen -t rsa -N "" -f "${PRIVATE_KEY}"

echo "Adding key ${PUBLIC_KEY} to authorized keys"
cat "${HOME}/.ssh/id_rsa.pub" >> "${AUTHORIZED_KEYS}"

echo "Host *
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
" >> "${CONFIG}"