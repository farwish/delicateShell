#!/bin/bash

#----------------------------------------------------
# 拷贝部署脚本,修改前使用(先要保证程序已上传至./adm/)
# farwish_16/2/14_V0.1 BSD License
#----------------------------------------------------

cur_dir=$(pwd)
adm=${cur_dir}/adm/			# 存放压缩包的目录

back2="bak"					    # 备份的项目(目录)
olddir="project" 			  # 旧的在用项目(目录)
dir="newproject" 			  # 解压后临时项目(目录)
file="newproject.tar.gz"	# 待解压的压缩包

cd ${adm}

if [ ! -e ${file} ]; then
	echo ${adm}${file}"不存在!\n"
	exit 1
fi

read -p "请输入口令[farwish]:" -t 30 pass

	if [ $pass != "farwish" ]; then
		echo "口令错误"
		exit 2
	fi

echo "正在解压"${adm}${file}"..."

tar zxf ${file}

if [ ! -d ${adm}${dir} ]; then
	echo "解压失败"
	exit 3
fi

cd ${cur_dir}

rm -rf ${olddir} 	# 删除原项目目录

cp -r ${adm}${dir} ${cur_dir}/${olddir}

cp ${cur_dir}/${back2}/food/Conf/config.php ${cur_dir}/${olddir}/food/Conf/config.php

rm -rf ${adm}${dir}

echo "Deploy Success!"
