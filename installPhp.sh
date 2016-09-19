#!/bin/bash
# 先装MySQL, 后源码包安装Php
# @farwish

# 存档目录
arch_path=/opt/Archive/

# 软件安装目录
soft_path=/usr/local/

# PHP软件包位置
arch_path_php=${arch_path}php-5.6.25/

# PHP目录
php_path=${soft_path}php5.6.25/

# gd依赖包名
libpng_bagname=libpng-1.6.25.tar.gz
jpeg9_bagname=jpegsrc.v9b.tar.gz
freetype_bagname=freetype-2.7.tar.gz

# 解压后目录
libpng_src=libpng-1.6.25
jpeg9_src=jpeg-9b
freetype_src=freetype-2.7

# 依赖包地址
libpng_url=http://downloads.sourceforge.net/project/libpng/libpng16/1.6.25/${libpng_bagname}
jpeg9_url=http://www.ijg.org/files/${jpeg9_bagname}
freetype_url=http://downloads.sourceforge.net/project/freetype/freetype2/2.7/${freetype_bagname}


## PHP和附加组件的依赖包 ##
yum install -y libxml libxml2 libxml2-devel libpng libpng-devel libjpeg libjpeg-devel libmcrypt libmcrypt-devel freetype freetype-devel curl curl-devel openssl openssl-devel zlib-devel


cd ${arch_path}

echo "下载 "${libpng_bagname}" ... "
wget ${libpng_url}

echo "下载 "${jpeg9_bagname}" ... "
wget ${jpeg9_url}

echo "下载 "${freetype_bagname}" ... "
wget ${freetype_url}

if [ -e ${libpng_bagname} ]; then
	echo "正在解压 "${libpng_bagname}"..."
	tar zxf ${libpng_bagname}

	if [ ! -d ${arch_path}${libpng_src} ]; then
		echo ${arch_path}${libpng_src}" 不存在"
		exit 1
	fi
fi

cd ${arch_path}${libpng_src}
./configure --prefix=/usr/local/libpng
make && make install


if [ -e ${jpeg9_bagname} ]; then
	echo "正在解压 "${jpeg9_bagname}"..."
	tar zxf ${jpeg9_bagname}

	if [ ! -d ${arch_path}${jpeg9_src} ]; then
		echo ${arch_path}${jpeg9_src}" 不存在"
		exit 2
	fi
fi

cd ${arch_path}${jpeg9_src}
./configure --prefix=/usr/local/jpeg9
make && make install


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


if [ ! -d ${arch_path_php} ]; then
	echo "下载PHP..."
	wget http://cn2.php.net/distributions/php-5.6.25.tar.gz
	tar zxf php-5.6.25.tar.gz
fi

echo "配置PHP..."

cd ${arch_path_php}

# mysql5.7 不再支持 --with-mysql 和 --with-mysqli
# 要使用非pdo等其它驱动，推荐使用mysqlnd：http://php.net/manual/en/mysqlinfo.library.choosing.php
# ./configure --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-mysql=mysqlnd
./configure --with-libdir=lib64 --prefix=${php_path} --with-pdo-mysql=/usr/local/mysql --enable-inline-optimization --enable-fpm --with-freetype-dir=/usr/local/freetype --with-gd --with-zlib --with-png-dir=/usr/local/libpng --with-jpeg-dir=/usr/local/jpeg9 --enable-mbstring --with-iconv --enable-sockets --with-curl --with-mcrypt --with-openssl --enable-pcntl --enable-soap --enable-opcache

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

echo "启动PHP..."
init.d.php-fpm start
