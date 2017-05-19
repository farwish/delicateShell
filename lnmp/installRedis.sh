#!/bin/bash
# Redis3.2.4源码安装.
# @farwish.com BSD-License

current_path=`pwd`
redis_url=http://download.redis.io/releases/redis-3.2.4.tar.gz
redis_dir=redis-3.2.4
redis_pkg_ext=.tar.gz
redis_src=${current_path}/${redis_dir}
redis_install_path=/usr/local/redis

yum install -y wget gcc* cmake bison

yum install -y tcl-devel.x86_64

if [ ! -d $redis_src ]; then
	wget $redis_url
	tar zxf ${redis_dir}${redis_pkg_ext}
fi

cd ${redis_src}

echo "编译安装(见README).."
make && make PREFIX=$redis_install_path install

echo "
	 ---------------- Recommend configure. -------------------"

echo "
	| Port           : 6379                                   
	| Config file    : ${redis_install_path}/etc/redis.conf   
	| Log file       : ${redis_install_path}/log/redis.log    
	| Data dir       : ${redis_install_path}/data             
	| Executable     : ${redis_install_path}/bin/redis-server"

echo " 
	 ---------------------------------------------------------"

mkdir ${redis_install_path}/etc/
mkdir ${redis_install_path}/log/
mkdir ${redis_install_path}/data/

cp ${redis_src}/redis.conf ${redis_install_path}/etc/

#sh "$redis_src"/utils/install_server.sh

# 解决可能的WARNING
ulimit -n 10032
echo '* soft nofile 10032' >> /etc/security/limits.conf

echo 511 > /proc/sys/net/core/somaxconn
echo 'net.core.somaxconn = 551' >> /etc/sysctl.conf

echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 'echo never >> /sys/kernel/mm/transparent_hugepage/defrag' >> /etc/rc.local
echo 'echo never >> /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.local

# 加自启动
echo '/usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf &' >> /etc/rc.local

echo -e "\nCompleted.\n"

echo "[ 环境变量 & 启动 ]"
echo "1. 手动将 :${redis_install_path}/bin 加入 /ect/profile"
echo "2. 修改配置文件 ${redis_install_path}/etc/redis.conf"
echo "   建议："
echo "        daemonize yes"
echo "        dir /usr/local/redis/data"
echo "        logfile /usr/local/redis/log/redis-server.log"
echo "3. 启动 redis-server ${redis_install_path}/etc/redis.conf"

cd ${current_path}

rm -rf ${redis_dir}
rm -rf ${redis_dir}${redis_pkg_ext}
