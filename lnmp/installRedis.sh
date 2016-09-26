#!/bin/bash
# Redis3.2.4源码安装.
# @farwish.com BSD-License

current_path=`pwd`
redis_url=http://download.redis.io/releases/redis-3.2.4.tar.gz
redis_dir=redis-3.2.4
redis_pkg_ext=.tar.gz
redis_src=${current_path}/${redis_dir}
redis_install_path=/usr/local/redis

if [ ! -d $redis_src ]; then
	wget $redis_url
	tar zxf ${redis_dir}${redis_pkg_ext}
fi

cd ${redis_src}

echo "安装依赖.."
yum install -y tcl-devel.x86_64

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

sh "$redis_src"/utils/install_server.sh

# Server Usage:
# /etc/init.d/redis_6379 start|stop|restart|status

echo "Completed."
