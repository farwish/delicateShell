#!/bin/bash
# 先装MySQL, 后源码包安装Php
# 备注：1. 本脚本不使用下载最新libpng、libjpeg, PHP不支持, 是使用yum安装的.
#       2. 默认只支持PDO, 不再支持--with-mysql, --with-mysqli.
# @farwish.com BSD-License

# 存档目录
arch_path=/opt/Archive/

# 软件安装目录
soft_path=/usr/local/

# PHP软件包位置
arch_path_php=${arch_path}php-5.6.25/

# PHP目录
php_path=${soft_path}php5.6.25/

# gd依赖包名
freetype_bagname=freetype-2.7.tar.gz

# 解压后目录
freetype_src=freetype-2.7

# 依赖包地址
freetype_url=http://downloads.sourceforge.net/project/freetype/freetype2/2.7/${freetype_bagname}

## PHP和附加组件的依赖包 ##
yum install -y libxml libxml2 libxml2-devel libpng libpng-devel libjpeg libjpeg-devel libmcrypt libmcrypt-devel freetype freetype-devel curl curl-devel openssl openssl-devel zlib-devel


cd ${arch_path}

echo "下载 "${freetype_bagname}" ... "
wget ${freetype_url}

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

echo "下载PHP..."
wget http://cn2.php.net/distributions/php-5.6.25.tar.gz
tar zxf php-5.6.25.tar.gz

echo "配置PHP..."

cd ${arch_path_php}

# mysql5.7 不再支持 --with-mysql 和 --with-mysqli
# 要使用非pdo等其它驱动，推荐使用mysqlnd：http://php.net/manual/en/mysqlinfo.library.choosing.php
# ./configure --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-mysql=mysqlnd
# 注意：不使用上面下载的最新libpng、libjpeg，PHP不支持，就用yum安装的.
./configure --with-libdir=lib64 --prefix=${php_path} --with-pdo-mysql=/usr/local/mysql --enable-inline-optimization --enable-fpm --with-freetype-dir=/usr/local/freetype --with-gd --with-zlib --with-png-dir --with-jpeg-dir --enable-mbstring --with-iconv --enable-sockets --with-curl --with-mcrypt --with-openssl --enable-pcntl --enable-soap --enable-opcache

echo "编译PHP..."

make && make install

echo "准备配置文件..."

cp php.ini-production ${php_path}lib/php.ini
cp ${php_path}etc/php-fpm.conf.default ${php_path}etc/php-fpm.conf
cp ${arch_path_php}sapi/fpm/init.d.php-fpm ${php_path}sbin/init.d.php-fpm
chmod +x ${php_path}sbin/init.d.php-fpm

echo "设置环境变量..."

echo -n ":"${php_path}"bin:"${php_path}"sbin" >> /etc/profile
source /etc/profile

echo "请手动启动PHP: init.d.php-fpm start"
# init.d.php-fpm start
