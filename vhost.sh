#!/bin/bash
# Nginx虚拟主机管理脚本V1.0
# @farwish.com BSD-License

echo "
 --------------------------------
|                                |
| 欢迎使用Nginx虚拟主机管理脚本  |
|                                |
 --------------------------------"

# 输入检测
read -p "请输入Nginx所安装目录(如:/usr/local/nginx):" -t 30 nginxdir

	# 注意不正确的语法: [ -z "$nginxdir" || ! -d "$nginxdir" ]
	if [ -z "$nginxdir" ] || [ ! -d "$nginxdir" ]
		then
			echo "Error:输入的不是目录"
			exit 1
	fi
													 
read -p "请输入Nginx虚拟主机地址(如:abc.example.com):" -t 30 vhostaddr

	if test -z "$vhostaddr"; then
		echo "Error:输入不正确"
		exit 2
	fi

read -p "请输入Nginx虚拟主机端口(如:80):" -t 30 vhostport

	# sed 's/^[0-9]*$//g' 如果替换之后为空,则是数字
	port=$(echo "$vhostport" | sed 's/^[0-9]*$//g')
	if [ ! -z "$port" ]; then
		echo "Error:输入的不是数字"
		exit 3
	fi

	if [ ! "$vhostport" -gt 0 ]; then
		echo "Error:输入的数字不正确"
		exit 4
	fi

read -p "请输入Nginx虚拟主机访问目录(如:/home/www/abc):" -t 30 wwwdir

	if [ -z "$wwwdir" ]; then
		echo "Error:没有输入目录";
		exit 5
	fi

# 确认输入
echo "
Nginx的目录是:"$nginxdir"
虚拟主机地址是:"$vhostaddr"
虚拟主机端口是:"$vhostport"
虚拟主机访问目录是:"$wwwdir"
-----------------------------------------------------"

read -p "请确认您的输入(y/n):" -t 30 enter

# 虚拟机配置项

confaddr=$nginxdir"/conf/vhost/"$vhostaddr".conf"

confitem() {
echo "	server {"
echo "		listen       "$vhostport";"
echo "		server_name  "$vhostaddr";"
echo ""
echo "		location / {"
echo "			index  index.html index.htm index.php;"
echo "			root   "$wwwdir";"
echo "			if (!-e $request_filename){"
echo "				#rewrite ^(.*)$ /index.php/?s=$1 last;"
echo "				break;"
echo "			}"
echo "		}"
echo ""
echo "		location ~ \.php {"
echo "			root           "$wwwdir";"
echo "			fastcgi_pass   127.0.0.1:9000;"
echo "			fastcgi_index  index.php;"
echo "			fastcgi_split_path_info ^(.+\.php)(.*)$;"
echo "			fastcgi_param PATH_INFO $fastcgi_path_info;"
echo "			fastcgi_param SCRIPT_FILENAME  $document_root$fastcgi_script_name;"
echo "			include        fastcgi_params;"
echo "		}"
echo "	}"
}

if [ "$enter" == "y" ]
	then
		# 检测是否已有目录
		if [ -d "$wwwdir" ]; then
			read -p "[注意: 目录 "$wwwdir" 已存在] 是否覆盖(y/n):" -t 30 entertwo
			
			if test "$entertwo" == "n"
				then
					read -p "请重新输入虚拟主机访问目录:" -t 30 wwwdir
				else
					echo "...删除目录"$wwwdir
					rm -rf "$wwwdir"
			fi
		fi

		# 新建主机访问目录
		echo "...创建目录"$wwwdir
		mkdir "$wwwdir"

		# 检测配置文件是否已存在
		if [ -e "$confaddr" ]; then
			read -p "[注意: 配置文件 "$confaddr" 已存在] 是否覆盖(y/n):" -t 30 enterthree

			if test "$enterthree" == "n"
				then
					read -p "请重新输入虚拟主机配置文件名(如:bcd.example.com.conf):" -t 30 confaddr

					# 新配置文件名
					confaddr=$nginxdir"/conf/vhost/"$confaddr
				else
					echo "...删除配置文件"$confaddr
					rm -rf "$confaddr"
			fi
		fi

		echo "...新建配置文件"$confaddr
		touch "$confaddr"

		confitem > "$confaddr"

		echo "...完成!"
	else
		exit 6
fi
