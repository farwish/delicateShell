#!/bin/bash
# 安装Phalcon框架及devtools, 用Root权限.
# ( 不建议使用了，说明如下 )
# @farwish.com BSD-License

# 请根据官方最新文档来安装.
# Example:
#
# git clone -b v3.0.2 https://github.com/phalcon/cphalcon.git
# cd cphalcon/build/php7/64bits/
# /usr/local/php7.0.14/bin/phpize
# ./configure --with-php-config=/usr/lcoal/php7.0.14/bin/php-config
# make && make install

# First step：add extension=phalcon.so in php.ini !
# Then run this script.
# Restart php-fpm.

echo "
 ----------------------------------------------
| 欢迎使用使用安装脚本.                        |
| 以下填写 Phalcon 和 phalcon-devtools 的版本. |
 ----------------------------------------------
"

current_path=`pwd`
cphalcon_url=git://github.com/phalcon/cphalcon.git
phalcon_devtools_url=git://github.com/phalcon/phalcon-devtools.git
phalcon_version=phalcon-v2.0.13
phalcon_tool_version=v2.0.13

read -p "请输入要安装的 Phalcon tag版本( 不填默认 $phalcon_version ):" -t 30 cphalcon_tag

read -p "请输入要安装的 phalcon-devtools tag版本( 不填默认 $phalcon_tool_version ):" -t 30 phalcon_devtools_tag

if [ -z $cphalcon_tag ]; then
    cphalcon_tag=$phalcon_version
fi

if [ -z $phalcon_devtools_tag ]; then
    phalcon_devtools_tag=$phalcon_tool_version
fi

if [ ! -d ${current_path}/cphalcon ]; then

    yum -y install git

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

echo "Complete! "
