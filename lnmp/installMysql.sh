#!/bin/bash
# 源码包安装MySQL-5.7.15
# @farwish.com BSD-License

archiveDir=/opt/Archive

if [ -d $archiveDir ]; then
    mkdir /opt/Archive
    cd $archiveDir
fi

wget http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.15.tar.gz

tar zxf mysql-5.7.15.tar.gz

# 依赖包
yum install -y cmake gcc-g++ ncurses-devel.x86_64
 
# 新用户, 用户组
groupadd mysql
useradd -r -g mysql -s /bin/false mysql

# 编译安装
cd /opt/Archive/mysql-5.7.15

cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/usr/local/mysql/data -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost_for_mysql

make && make install

cd /usr/local/mysql

# 更改所有者
chown -R mysql:mysql .

# 初始化基础数据库
# data-directory-initialize: http://dev.mysql.com/doc/refman/5.6/en/data-directory-initialization.html
# /usr/local/mysql/scripts/mysql_install_db --user=mysql --datadir=/usr/local/mysql/data --explicit-defaults-for-timestamp
./bin/mysqld --initialize --user=mysql --datadir=/usr/local/mysql/data --explicit-defaults-for-timestamp

# 复制模板配置文件
cp ./support-files/my-default.cnf /etc/my.cnf

# 环境变量, -n 不输出换行, 便于后面php环境变量追加连接
if [ -e /ect/my.cnf ]; then
    echo -n 'PATH=$PATH:/usr/local/mysql/bin' >> /etc/profile
    source /etc/profile

# 手动配置项
# vi /etc/my.cnf
# datadir=/usr/local/mysql/data
# 去掉 /etc/my.cnf 里面的( ,STRICT_TRANS_TABLES )；这样便不会严格检查字段默认值，详情见：
#    http://dev.mysql.com/doc/refman/5.7/en/sql-mode.html#sqlmode_strict_trans_tables
# 防止insert等操作没有默认值时报错,本条不再有效: 加入跟随 STRICT_TRANS_TABLES 的选项, 文件结尾没有换行时可以用命令. ( echo -n ,ERROR_FOR_DIVISION_BY_ZERO,NO_ZERO_DATE,NO_ZERO_IN_DATE,NO_AUTO_CREATE_USER >> /etc/my.cnf )

# 启动
# ./support-files/mysql.server start

    echo "--------------------------------------------------------"
    echo "Install finished!"
    echo "After set /etc/my.cnf , you could start mysql manually!"
    echo "Start: /usr/local/mysql/support-files/mysql.server start"
    echo "Update password above immeditialy , example:"
    echo " ( alter user 'root'@'localhost' identified by '123456' )"
    echo "--------------------------------------------------------"  
fi

