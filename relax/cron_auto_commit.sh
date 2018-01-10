#!/bin/bash
#
# Usage:
#
# 1. apt install expect -y
# 2. update script projectdir and username/passwd by yourself.
# 3. set crontab: 0 18 * * * /bin/sh /home/fw/cron_auto_commit.sh >> /home/fw/cron_auto_commit.log 2>&1
#
# @license BSD-3
# @author farwish <farwish@foxmail.com>
#

echo `date`

cd /home/fw/projectdir

expect -c "
    set timeout 10

    spawn git add -A

    spawn git commit -m 'cron auto commit'

    spawn git fetch origin -p

    spawn git rebase origin master

    spawn git push origin master

    expect {
        "Username" { send \"myname\r\"; exp_continue }
        "Password" { send \"passwd\r\" }
    };

    expect eof;
"

echo "Done"
