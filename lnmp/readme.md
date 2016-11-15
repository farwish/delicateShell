## lnmp环境独立安装脚本.

> 可在ECS的CentOS7.0-64bit系统中可靠运行。

> 运行顺序：

>    installMysql.sh  
>    ( curl -sS https://github.com/farwish/delicateShell/blob/master/lnmp/installMysql.sh | sh )
>    installPhpUseDefaultLibpng.sh  
>    installNginx.sh  
>    installPhalcon.sh # 框架  
>    installRedis.sh  

## 管理.

> [ redis ]

> Usage: redis start|stop|restart|status

> `cp /etc/init.d/redis_6379 /usr/local/redis/bin`  
> `redis start` # 启动redis

--

> [ mysql ]

> Usage: mysql.server  {start|stop|restart|reload|force-reload|status}  [ MySQL server options ]

> `mysql.server start` # 启动 mysql

--

> [ php-fpm ]

> Usage: init.d.php-fpm {start|stop|force-quit|restart|reload|status}

> `init.d.php-fpm start` # 启动 php-fpm

--

> [ nginx ]

> Usage: nginx [-?hvVtTq] [-s signal] [-c filename] [-p prefix] [-g directives]

> `nginx`  # 启动 nginx；安装时已制定配置文件，所以可以省略制定配置文件  
> `nginx -s reload` # 重载工作进程，使配置生效  
> `pkill -9 nginx` # 关闭 nginx  

--
