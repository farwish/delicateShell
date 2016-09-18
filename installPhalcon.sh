#!/bin/bash
# 安装Phalcon框架及devtools, 用Root权限.
# @farwish  BSD-License

current_path=`pwd`
cphalcon_url=git://github.com/phalcon/cphalcon.git
cphalcon_tag=v3.0.1
phalcon_devtools_url=git://github.com/phalcon/phalcon-devtools.git
phalcon_devtools_tag=v3.0.1

if [ ! -d ${current_path}/cphalcon ]; then

    echo "下载cphalcon..."

    git clone -b ${cphalcon_tag} ${cphalcon_url}

fi

echo "安装phalcon..."

cd ${current_path}/cphalcon/build

./install

cd ${current_path}

if [ ! -d ${current_path}/phalcon-devtools ]; then

    echo "下载phalcon-devtools..."

    git clone -b ${phalcon_devtools_tag} ${phalcon_devtools_url}

fi

echo "安装phalcon-devtools..."

sh ${current_path}/phalcon-devtools/phalcon.sh

echo "phalcon.php 命令加入/usr/bin/phalcon"

ln -s ${current_path}/phalcon-devtools/phalcon.php /usr/bin/phalcon

echo "完毕! 请将 extension=phalcon.so 加入php.ini , 重启php-fpm!"
