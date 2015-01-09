#!/bin/bash

set -e

/set_root_pw.sh
exec sudo /usr/sbin/sshd -D
