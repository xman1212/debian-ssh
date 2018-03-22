#!/bin/bash

echo 1
service mongodb start
echo 2
cd /game/server/etc
python gen_conf.py 4000 $GAME_HOST_IP
echo 3
cd ../bin
echo 4
bash run_server.sh
echo 5
cd ../script/rpyc_server
bash run.sh
echo 6

set -e
echo 6
/set_root_pw.sh
echo 6
exec /usr/sbin/sshd -D
echo 6
