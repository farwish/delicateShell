#/bin/bash
# 一些php扩展安装
# @farwish.com BSD-License

pecl install eio

yum install -y libevent-devel.x86_64
pecl install libevent-0.1.0
