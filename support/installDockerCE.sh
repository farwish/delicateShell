#!/bin/bash
# Install newest version of docker-ce. 
# @farwish.com BSD-License

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
yum makecache fast

# Show source packages 
newestVersion=`yum list docker-ce.x86_64 --showduplicates | sort -r | grep docker | awk '{print $2}' | sed -n '1p'`

if test -n $newestVersion; then

    # Install the latest version of docker-ce : yum install docker-ce
    #yum install docker-ce-<VERSION>
    yum install -y docker-ce-$newestVersion

    # Start docker
    systemctl start docker

    # Verify docker is installed correctly by running the hello-world image
    docker run hello-world
else
    echo "No valid version of docker-ce."
fi

# Upgrade docker-ce should start from step 2.

# Remove docker-ce : yum remove docker-ce.x86_64
