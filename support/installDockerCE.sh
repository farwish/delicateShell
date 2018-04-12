#!/bin/bash
# Install newest version of docker-ce. 
# Either CentOS or Ubuntu.
# @doc https://docs.docker.com/engine/installation/linux/docker-ce/centos/
# @doc https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
# @author farwish.com BSD-License

set -e

kernel_release=`uname -r`
primary=`echo -n $kernel_release | cut -d . -f 1`
senior=`echo -n $kernel_release | awk 'BEGIN{FS="."} {printf $2}'`

arch_check() {
    # check hardware naem
    case "$(uname -m)" in
        *64)
            ;;
        *)
            echo -e "
    Error: you are not using a 64bit platform.
    Docker currently only supports 64bit platforms.\n"
            ;;
    esac
}

# Execute start, autostart, groupadd in sequence at the docker

execute_start_autostart_groupadd() {

    # Start docker
    systemctl start docker

    # Auto start docker
    systemctl enable docker.service

    # Verify docker is installed correctly by running the hello-world image
    docker run hello-world

    # Docker Group
    gname=`cat /etc/group | grep docker | cut -d : -f 1`

    if [ -z $gname ]; then
        groupadd docker
    fi

    # 除root外，需要执行docker命令的用户加入docker组
    # usermod -aG docker $USER

    echo -e "
完成!\n		
要将普通用户加入docker组, 执行如 'usermod -aG docker weichen'
要使新加入docker组的用户生效(能执行 docker 命令), 请重启操作系统.\n"
}

################### CentOS ####################

# Remove older versions of Docker on CentOS, not DockerCE

uninstall_yum_old() {
    yum remove -y docker \
    docker-common \
    docker-selinux \
    docker-engine
}

# Add Repo

yum_repo_check() {
        
    # 0.Dependency
    yum install -y yum-utils device-mapper-persistent-data lvm2

    # 1.Set up the stable repository
    dockerCeRepo=/etc/yum.repos.d/docker-ce.repo

    if ! test -e $dockerCeRepo; then
        yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo

        # Optional: edge and test repositories are disabled by default.
        #yum-config-manager --enable docker-ce-edge
        #yum-config-manager --enable docker-ce-test
    fi

    # 2.Update the yum package index
    yum makecache -y fast
}

# Install

do_centos_install() {
    arch_check
    uninstall_yum_old
    yum_repo_check

    # Show source packages 
    newestVersion=`yum list docker-ce.x86_64 --showduplicates | sort -r | grep docker | awk '{print $2}' | sed -n '1p'`

    if test -n $newestVersion; then

        # Install the latest version of docker-ce : yum install docker-ce
        #yum install docker-ce-<VERSION>
        yum install -y docker-ce-$newestVersion

        execute_start_autostart_groupadd
    else
        echo "No valid version of docker-ce."
    fi
}

# Upgrade docker-ce should start from step 2.

do_centos_upgrade() {
    do_centos_install
}

# Remove docker-ce : yum remove docker-ce.x86_64

do_centos_uninstall() {
    echo "Inform:"
    read -p "Uninstall just remove the package, does not remove images, containers, volumes, or user-created configuration files on your host, do you want to continue? (y/n)" -t 30 answer

    if [ $answer == 'n' ]; then
        echo "You stop the action!"
        exit 1
    else
        rows=`yum list installed | grep docker | awk '{print $1}'`
        for pkgname in $rows; do
            yum -y remove $pkgname
        done

        groupdel docker

        echo -e "
Finished!\n
To delete all images, containers, and volumes, run the following command:
'rm -rf /var/lib/docker'\n"
    fi
}

################### Ubuntu ####################

# Remove older versions of Docker on Ubuntu, not DockerCE

uninstall_apt_old() {
    apt-get remove -y docker docker-engine docker.io
}

# Install

do_ubuntu_install() {
    arch_check
    uninstall_apt_old

    # 0
    apt-get update -y

    # 1
    apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

    # 2
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88

    # 3
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
    
    # Install latest version of Docker CE
    apt-get update -y
    apt-get install -y docker-ce

    execute_start_autostart_groupadd
}

# Upgrade

do_ubuntu_upgrade() {
    apt-get -y update
    do_ubuntu_install
}

# Uninstall

do_ubuntu_uninstall() {
    apt-get purge -y docker-ce

    groupdel docker
    
    echo -e "
Finished!\n
To delete all images, containers, and volumes, run the following command:
'rm -rf /var/lib/docker'\n"
}

################### Run All ####################

if test -e /etc/centos-release; then

    os_major_version=`cat /etc/centos-release | awk '{printf $4}' | cut -d . -f 1`

    if test $((os_major_version)) -lt  7; then
        echo "To install Docker CE, you need the 64-bit version of CentOS 7."
    else
        echo "Centos version check crossed."

        do_centos_install
        #do_centos_upgrade
        #do_centos_uninstall
    fi

elif test -e /etc/lsb-release; then 

    #os_codename=`cat /etc/lsb-release | grep CODENAME | cut -d = -f 2`
    os_codename=`lsb_release -cs`
    os_release=`cat /etc/lsb-release | grep RELEASE | cut -d = -f 2`

    # @see https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#os-requirements
    if [ "$os_codename" == "zesty" -a "$os_release" == "17.04" ] || [ "$os_codename" == "xenial" -a "$os_release" == "16.04" ] || [ "$os_codename" == "zesty" -a "$os_release" == "17.04" ] || [ "$os_codename" == "trusty" -a "$os_release" == "14.04" ]; then
        echo "Ubuntu version check crossed."

        do_ubuntu_install
        #do_ubuntu_upgrade
        #do_ubuntu_uninstall
    else
        echo "To install Docker CE, you need the 64-bit version of one of these Ubuntu versions: Zesty 17.04 / Xenial 16.04 (LTS) / Trusty 14.04 (LTS)"
    fi

else
    echo "OS is not Centos or Ubuntu."
fi

