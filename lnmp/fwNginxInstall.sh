#!/bin/bash
# Must checkout to sudoers.
# @farwish.com BSD-License

indexOfDownload="http://nginx.org/download/"
defaultVersion="nginx-1.10.1"
nginxArchiveDir="/opt/"
nginxInstallDir="/usr/local/nginx/"

echo "
Welcome to use Nginx installation script!"

echo "
Index of nginx source is ${indexOfDownload}"

read -p "
Please input the version name (example: nginx-1.10.1 , Press Enter key will use ${defaultVersion}): " version

# If empty, select the default.
if test -z ${version}; then
    version=${defaultVersion}
fi

read -p "
Do you want to clear the source package downloaded after the install ? (Press Enter key is yes,     other is false)" clearSourcePackage

gzFile=${version}.tar.gz
getUrl=${indexOfDownload}${gzFile}

# Archive dir
cd ${nginxArchiveDir}

# If without unzip directory and zip file, exec wget.
if ! test -d ${version} && ! test -f ${gzFile}; then
    wget ${getUrl}
else
    echo "
    ${gzFile} has exists, ignore wget!"
fi

# If without unzip directory, exec tar.
if ! test -d ${version}; then
    tar zxf ${gzFile}
else
    echo "
    ${version}/ has exists, ignore tar!"
fi

# Do Install
cd `pwd`/${version}

yum install -y wget gcc* cmake bison

# the HTTP rewrite module requires the PCRE library.
yum install -y pcre-devel.x86_64

# the HTTP gzip module requires the zlib library
yum install -y zlib-devel.x86_64

echo "...Congiure Nginx..."

./configure --prefix=${nginxInstallDir} --conf-path=${nginxInstallDir}conf/nginx.conf

make && make install

echo -e "\nComplete!\n"

echo "[ Set Environment Variable and Start ]"
echo "1. input PATH=\$PATH:${nginxInstallDir}sbin into /etc/profile"
echo "2. source /etc/profile && nginx\n"

# Clear
if test -z ${clearSourcePackage}; then
    rm -rf ${nginxArchiveDir}${gzFile}
    rm -rf ${nginxArchiveDir}${version}
fi
