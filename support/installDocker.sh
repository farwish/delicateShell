#!/bin/bash
# Centos7安装Docker.
# @farwish.com BSD-License

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

repo_check() {
    # check repo config
    dockerfile=/etc/yum.repos.d/docker.repo
    dockerrepo="[dockerrepo]
\nname=Docker Repository
\nbaseurl=https://yum.dockerproject.org/repo/main/centos/7/
\nenabled=1
\ngpgcheck=1
\ngpgkey=https://yum.dockerproject.org/gpg"

    if [ -e ${dockerfile} ]; then
        read -p "文件 $dockerfile 以存在, 是否覆盖? (y/n)" -t 30 answer
        if [ -z $answer ] || [ $answer != 'y' ]; then
            echo 'You stop the action!'
            exit 1
        else
            echo -e $dockerrepo > $dockerfile
        fi
    else
        echo -n $dockerrepo > $dockerfile
    fi
}

do_install() {
    arch_check
    repo_check

    # install steps
    yum install -y docker-engine
    systemctl enable docker.service
    systemctl start docker

    gname=`cat /etc/group | grep docker | cut -d : -f 1`
    if [ -z $gname ]; then
        # 新用户组
        groupadd docker
    fi

    read -p "输入要加入docker用户组的用户名[不输默认当前用户]:" -t 30 yourname

    if [ -z $yourname ]; then
        yourname=`whoami`
    fi

    if [ -n $yourname ]; then
        # 用户加入docker组
        usermod -aG docker $yourname
    fi

    echo -e "Complete!\n
Verify docker is installed correctly by running a test image in a container: 'docker  run --rm hello-world'."
}

un_install() {
    echo "Inform:"
    read -p "Uninstall just remove the package, does not remove images, containers, volumes, or user-created configuration files on your host, do you want to continue? (y/n)" -t 30 answer

    if [ -z $answer ] || [ $answer != 'y' ]; then
        echo "You stop the action!"
        exit 2
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

do_install
#un_install
