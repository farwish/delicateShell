#!/bin/bash
# Nginx安装
# @farwish.com BSD-License

arch_path=/opt/Archive/

nginx_path=/usr/local/nginx/

nginx_bagname=nginx-1.10.1.tar.gz

nginx_src=nginx-1.10.1

if [ ! -e ${nginx_bagname} ]; then
	wget http://nginx.org/download/nginx-1.10.1.tar.gz
	tar zxf ${nginx_bagname}
fi

cd ${arch_path}${nginx_src}

echo "配置编译Nginx..."

./configure --prefix=${nginx_path} --conf-path=${nginx_path}conf/nginx.conf

make && make install

echo "设置环境变量..."
echo -n ":/usr/local/nginx/sbin" >> /etc/profile

echo "启动..."
nginx

echo "Done!"
