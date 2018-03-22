#!/bin/bash

service mongodb start
cd /game/server/etc
python gen_conf.py 4000 $GAME_HOST_IP
cd ../bin
bash run_server.sh
cd ../script/rpyc_server
bash run.sh
tailon -b 0.0.0.0:8080 -f /game/server/log/*.log &

set -e
/set_root_pw.sh
exec /usr/sbin/sshd -D
