#!/bin/bash
set -eu

if [ -r /etc/lsb-release ]; then
  distribution=$(grep "DISTRIB_ID" /etc/lsb-release | sed -e "s/^DISTRIB_ID=//")
  if [ $distribution = "Ubuntu" ]; then
    # Ubuntu
    apt update
    apt -y install automake bison build-essential git libevent-dev libncurses5-dev pkg-config
  fi
elif [ -r /etc/centos-release ]; then
  # CentOS
  yum check-update
  yum -y groupinstall "Development Tools"
  if [ "$(grep '^CentOS release 6' /etc/centos-release)" ]; then
    # CentOS 6
    yum -y install libevent2-devel ncurses-devel
  elif [ "$(grep '^CentOS Linux release 7' /etc/centos-release)" ]; then
    # CentOS 7
    yum -y install libevent-devel ncurses-devel
  fi
else
  exit 1
fi

cd /tmp
git clone --depth 1 https://github.com/tmux/tmux
cd ./tmux/
./autogen.sh
./configure --prefix=/usr/local
make
make install
which tmux
tmux -V
