#/bin/bash
# php扩展全家桶. ( 不建议使用了, 说明如下 )
# @farwish.com BSD-License
#
# 根据需要用 pecl 安装所需常用扩展. 
# Example:
#
# /usr/lcoal/php7.0.14/bin/pecl install redis-3.0.0
# /usr/lcoal/php7.0.14/bin/pecl install yar-2.0.1
# /usr/lcoal/php7.0.14/bin/pecl install swoole-1.9.1
#

php_path=/usr/local/php5.6.25/
cur_dir=`pwd`
yum install -y git

# extension=eio.so
pecl install eio

# extension=libevent.so
yum install -y libevent-devel.x86_64
pecl install libevent-0.1.0

# extension=redis.so
if [ ! -d ${cur_dir}/phpredis ]; then
    git clone -b 2.2.8 https://github.com/phpredis/phpredis.git
fi
cd phpredis
phpize
./configure --with-php-config=${php_path}bin/php-config
make && make install

# extension=swoole.so
pecl install swoole

echo -e "\nCompleted! 要在php.ini中加入的配置有:\n"
echo -e "extension=eio.so
extension=libevent.so
extension=redis.so
extension=swoole.so\n"
