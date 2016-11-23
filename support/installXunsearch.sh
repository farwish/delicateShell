#!/bin/bash
# Xunsearch1.4.10 简明安装
# @farwish.com BSD-License

set -e

currentDir=`pwd`
installDir=/usr/local/xunsearch/
package=xunsearch-full-latest.tar.bz2
dirname=xunsearch-full-1.4.10

cd $currentDir

if ! test -e $package; then
    yum install -y wget
    wget http://www.xunsearch.com/download/xunsearch-full-latest.tar.bz2
fi

tar -xjf $package

cd $dirname

sh setup.sh

echo -e "\n启动...\n"

${installDir}bin/xs-ctl.sh start

echo -e "\nPHP环境检测...\n"

php ${installDir}sdk/php/util/RequiredCheck.php
