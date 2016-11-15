#!/bin/bash
# 源码包安装MySQL-5.7.15
# 适用centos7-64bit,其余可以尝试.
# @farwish.com BSD-License

archiveDir=/opt/Archive
mysqlSource=http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.15.tar.gz
mysqlGz=mysql-5.7.15.tar.gz
mysqlName=mysql-5.7.15
installDir=/usr/local/mysql

# 最小化centos没有gcc-g++
echo '安装依赖包...'
yum install -y wget gcc* cmake bison ncurses-devel.x86_64

if [ -d $archiveDir ]
    then
        cd $archiveDir
    else
        mkdir $archiveDir
        cd $archiveDir
fi

if [ -f ${archiveDir}/${mysqlGz} ]; then
    tar zxf ${archiveDir}/${mysqlGz}
else
    wget $mysqlSource
    tar zxf ${archiveDir}/${mysqlGz}
fi

if [ -d ${archiveDir}/${mysqlName} ]; then
    cd ${archiveDir}/${mysqlName}
fi

# 新用户, 用户组
groupadd mysql
useradd -r -g mysql -s /bin/false mysql

# 编译安装
cmake -DCMAKE_INSTALL_PREFIX=${installDir} -DMYSQL_DATADIR=${installDir}/data -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost_for_mysql

make && make install

cd ${installDir}

# 更改所有者
chown -R mysql:mysql .

# 初始化基础数据库
# data-directory-initialize: http://dev.mysql.com/doc/refman/5.6/en/data-directory-initialization.html
# 5.7之前使用的命令是：/usr/local/mysql/scripts/mysql_install_db --user=mysql --datadir=/usr/local/mysql/data --explicit-defaults-for-timestamp
./bin/mysqld --initialize --user=mysql --datadir=${installDir}/data --explicit-defaults-for-timestamp

# 复制模板配置文件
cp ./support-files/my-default.cnf /etc/my.cnf

# 环境变量, -n 不输出换行, 便于后面php环境变量追加连接
if [ -f /ect/my.cnf ]; then
    echo -n "PATH=$PATH:${installDir}/bin" >> /etc/profile

# 手动配置项
# vi /etc/my.cnf 加入：datadir=/usr/local/mysql/data
# 安装完成后，你会看到一些warning，在配置中加入下面的选项：
# ( echo -n ,ERROR_FOR_DIVISION_BY_ZERO,NO_ZERO_DATE,NO_ZERO_IN_DATE,NO_AUTO_CREATE_USER >> /etc/my.cnf )

# 启动
# ./support-files/mysql.server start

    echo "--------------------------------------------------------"
    echo "Install finished!"
    echo "After set /etc/my.cnf , you could start mysql manually!"
    echo "Start: ${installDir}/support-files/mysql.server start"
    echo "Update password above immeditialy , example:"
    echo " ( alter user 'root'@'localhost' identified by '123456' )"
    echo "--------------------------------------------------------"  
fi
