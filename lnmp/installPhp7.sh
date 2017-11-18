#!/bin/bash
# centos7安装php7.
# 备注：1. PHP不支持最新libpng、libjpeg, 所以本脚本中用yum安装这个两个依赖包.
#      2. 数据库扩展使用官方推荐的mysqlnd, 配置--with-mysql会有WARNING提示不推荐使用, 重复安装记住执行make clean.
# @farwish.com BSD-License

set -e

# 存档目录
arch_path=/opt/

# 软件安装目录
soft_path=/usr/local/

# Php版本 7.1 stable
default_version=php-7.1.4

read -p "
Please input php version (example: ${default_version} , default is ${default_version}) :" php_version

if test -z ${php_version}; then
    echo -e "\nSelect the default php version : ${default_version}\n"
    php_version=${default_version}
else
    echo -e "\nSelect the php version : ${php_version}\n"
fi

# PHP软件包位置
arch_path_php=${arch_path}php-src-${php_version}/

# PHP目录
php_path=${soft_path}${php_version}/

# gd依赖包名
freetype_bagname=freetype-2.7.tar.gz

# 解压后目录
freetype_src=freetype-2.7

# 依赖包地址
freetype_url=http://downloads.sourceforge.net/project/freetype/freetype2/2.7/${freetype_bagname}

yum install -y wget gcc* cmake bison

## PHP和附加组件的依赖包 ##
yum install -y libxml libxml2 libxml2-devel libpng libpng-devel libjpeg libjpeg-devel freetype freetype-devel curl curl-devel openssl openssl-devel zlib-devel

# ./buildconf needed
yum install -y autoconf.noarch

# centos7 kernel-3.10.237中已不含libmcrypt, 需自行下载
if [ ! -d libmcrypt-2.5.8 ]; then
        wget http://sourceforge.net/projects/mcrypt/files/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
        tar zxf libmcrypt-2.5.8.tar.gz
fi
cd libmcrypt-2.5.8
# 装在 /usr/local 下
./configure
make && make install

cd ${arch_path}

if [ ! -e ${freetype_bagname} ]; then
        echo "下载 "${freetype_bagname}" ... "
        wget ${freetype_url}
fi

if [ -e ${freetype_bagname} ]; then
        echo "正在解压 "${freetype_bagname}"..."
        tar zxf ${freetype_bagname}

        if [ ! -d ${arch_path}${freetype_src} ]; then
                echo ${arch_path}${freetype_src}" 不存在"
                exit 3
        fi
fi

cd ${arch_path}${freetype_src}
./configure --prefix=/usr/local/freetype
make && make install

cd ${arch_path}

if [ ! -d ${arch_path_php} ]; then
        echo "下载PHP..."
        wget https://github.com/php/php-src/archive/${php_version}.tar.gz
        tar zxf ${php_version}.tar.gz
fi

echo "配置PHP..."

cd ${arch_path_php}

./buildconf --force

# 官方推荐使用mysqlnd支持mysqli/pdo/mysql：http://php.net/manual/en/mysqlinfo.library.choosing.php
# ./configure --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-mysqlnd [--with-mysql=mysqlnd 不推荐使用]
# 注意：不使用上面下载的最新libpng、libjpeg，PHP不支持，就用yum安装的.
# 已开启线程安全(ZTS) --enable-maintainer-zts
# 开启调试模式加 --enable-debug，更多请看 ./configure --help.
./configure \
--with-libdir=lib64 \
--prefix=${php_path} \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-mysql \
--enable-mysqlnd \
--enable-inline-optimization \
--enable-fpm \
--with-freetype-dir=/usr/local/freetype \
--with-gd \
--with-zlib \
--with-png-dir \
--with-jpeg-dir \
--enable-mbstring \
--with-iconv \
--enable-sockets \
--with-curl \
--with-openssl \
--enable-pcntl \
--enable-soap \
--enable-calendar \
--enable-opcache=no \
--enable-bcmath \
--enable-maintainer-zts \

echo "编译PHP..."

make && make install

echo "准备配置文件..."

cp php.ini-production ${php_path}lib/php.ini
cp ${php_path}etc/php-fpm.conf.default ${php_path}etc/php-fpm.conf
cp ${arch_path_php}sapi/fpm/init.d.php-fpm ${php_path}sbin/init.d.php-fpm
chmod +x ${php_path}sbin/init.d.php-fpm  

# 注意：PHP7 已将 php-fpm.conf 分拆，需要执行：cd /usr/local/php7/etc/php-fpm.d/ && cp www.conf.default www.conf  
cd ${php_path}etc/php-fpm.d/
cp www.conf.default www.conf

echo -e "\nComplete!\n"

echo "[设置环境变量 & 启动 ]"
echo "1. 手动将 :${php_path}bin:${php_path}sbin 加入 /ect/profile，并 source /etc/profile"
echo -e "2. 手动启动PHP: init.d.php-fpm start\n"
# init.d.php-fpm start
