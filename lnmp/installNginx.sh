#!/bin/bash
# 源码安装Nginx
# @farwish.com BSD-License

archiveDir=/opt/Archive/
nginx_source_url=http://nginx.org/download/nginx-1.10.1.tar.gz
nginx_install_dir=/usr/local/nginx/
nginx_bagname=nginx-1.10.1.tar.gz
nginx_src=nginx-1.10.1

if [ ! -e ${archiveDir}${nginx_bagname} ]; then
	wget ${nginx_source_url}
	tar zxf ${archiveDir}${nginx_bagname}
fi

cd ${archiveDir}${nginx_src}

echo "配置编译Nginx..."

./configure --prefix=${nginx_install_dir} --conf-path=${nginx_install_dir}conf/nginx.conf

make && make install

echo "设置环境变量..."
echo -n ":${nginx_install_dir}sbin" >> /etc/profile

echo "启动..."
nginx

echo "Done!"
