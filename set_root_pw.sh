#!/bin/bash

if [ -z "${SSH_KEY}" ]; then
	echo "=> Please pass your public key in the SSH_KEY environment variable"
	exit 1
fi

USER=$(whoami)

echo "=> Adding SSH key for the user ${USER}"
mkdir -p ~/.ssh
chmod go-rwx ~/.ssh
echo "${SSH_KEY}" > ~/.ssh/authorized_keys
chmod go-rw ~/.ssh/authorized_keys

echo "=> Done!"
echo "========================================================================"
echo "You can now connect to this container via SSH using:"
echo ""
echo "    ssh -p <port> $USER@<host>"
echo "========================================================================"
