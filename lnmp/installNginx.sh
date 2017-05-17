#!/bin/bash
# 源码安装Nginx
# @farwish.com BSD-License

archiveDir=/opt/Archive/
nginx_source_url=http://nginx.org/download/nginx-1.10.1.tar.gz
nginx_install_dir=/usr/local/nginx/
nginx_bagname=nginx-1.10.1.tar.gz
nginx_src=nginx-1.10.1

if [ ! -d $archiveDir ]; then
    mkdir $archiveDir
fi

if [ ! -d $archiveDir ]; then
    exit 1
fi

cd $archiveDir

yum install -y wget gcc* cmake bison

# the HTTP rewrite module requires the PCRE library.
yum install -y pcre-devel.x86_64

# the HTTP gzip module requires the zlib library
yum install -y zlib-devel.x86_64

if [ ! -e ${archiveDir}${nginx_bagname} ]; then
    wget ${nginx_source_url}
fi

tar zxf ${archiveDir}${nginx_bagname}

if [ -d ${archiveDir}${nginx_src} ]; then
    cd ${archiveDir}${nginx_src}
else
    echo "目录 ${archiveDir}${nginx_src} 不存在"
    exit 2
fi

echo "配置编译Nginx..."

./configure --prefix=${nginx_install_dir} --conf-path=${nginx_install_dir}conf/nginx.conf

make && make install

echo -e "\nComplete!\n"

echo "[ 设置环境变量 & 启动 ]"
echo "1. 请手动将 :${nginx_install_dir}sbin 加入 /etc/profile"
echo "2. 启动使用 source /etc/profile && nginx\n"

#echo -n ":${nginx_install_dir}sbin" >> /etc/profile
#echo "启动..."
#nginx
