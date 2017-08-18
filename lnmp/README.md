## lnmp环境独立安装脚本.

可在ECS的CentOS7.0-64bit系统(标准镜像)中可靠运行。

推荐运行顺序 ( 非强制 )：  
* 当遇到提示你的系统缺少某个库时, 用yum安装好依赖, make clean 之后再执行一次安装脚本。  

---

### installMysql.sh ( Fixed version MySQL-5.7.15 )  

`curl -sS https://raw.githubusercontent.com/farwish/delicateShell/master/lnmp/installMysql.sh | sh`  

### installNginx.sh ( Not recommend old script, use fwNginxInstall.sh instead )  

`curl -sS https://raw.githubusercontent.com/farwish/delicateShell/master/lnmp/installNginx.sh | sh`  

### fwNginxInstall.sh ( Can choose version, default nginx-1.10.1 )    

`curl -sS https://raw.githubusercontent.com/farwish/delicateShell/master/lnmp/fwNginxInstall.sh | sh`    

### installPhpUseDefaultLibpng.sh  ( Fixed version php-5.6.25 )  

`curl -sS https://raw.githubusercontent.com/farwish/delicateShell/master/lnmp/installPhpUseDefaultLibpng.sh | sh`  

### installPhp7.sh  ( Can choose version, default php-7.1.4 )  

`curl -sS https://raw.githubusercontent.com/farwish/delicateShell/master/lnmp/installPhp7.sh | sh`  

### installRedis.sh ( Fixed version redis-3.2.4 )   

`curl -sS https://raw.githubusercontent.com/farwish/delicateShell/master/lnmp/installRedis.sh | sh`  

## 管理.

[ nginx ]

方式1 - 依靠在 /etc/profile 指定命令的PATH使用:  
```
$ nginx -h  
$ nginx 
$ nginx -s quit
```

方式2 - 用 service 命令运行系统级 /etc/init.d/* 脚本:  
```
$ ln -s /usr/local/nginx/sbin/nginx /etc/init.d/nginx
$ service nginx
$ service nginx -s reload
$ service nginx -s quit
```

[ mysql ]

方式1:  
```
$ mysql.server {start|stop|restart|reload|force-reload|status}  [ MySQL server options ]
```

方式2:  
```
$ ln -s /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql  
$ service mysql {start|stop|restart|reload|force-reload|status}  
```

[ php-fpm ]

方式1:  
```
$ init.d.php-fpm {start|stop|force-quit|restart|reload|status}  
```

方式2:  
```
$ ln -s /usr/local/php-7.1.4/sbin/init.d.php-fpm /etc/init.d/fpm
$ service fpm {start|stop|force-quit|restart|reload|status}
```

[ redis ]

方式1:  
```
$ redis-server -h
$ redis-server /usr/local/redis/etc/redis.conf
$ kill $(cat /var/run/redis_6379.pid)
```

方式2:
```
自己源码编译安装Redis不会生成启动脚本, 用官方的 utils/install_server.sh 安装后有启动脚本 /etc/init.d/redis_6379
官方的启动脚本模版为 utils/redis_init_script, 自行编写可以参考。
```
