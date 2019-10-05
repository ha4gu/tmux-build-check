#!/bin/bash
set -eu

if [ -r /etc/lsb-release ]; then
  distribution=$(grep "DISTRIB_ID" /etc/lsb-release | sed -e "s/^DISTRIB_ID=//")
  if [ $distribution = "Ubuntu" ]; then
    # Ubuntu
    apt-get -qq update
    apt-get -qq -y install automake bison build-essential git libevent-dev libncurses5-dev pkg-config
  else
    echo "[ERROR] Unknown distribution (seems to be debian-related one)."
    exit 1
  fi
elif [ -r /etc/centos-release ]; then
  # CentOS
  yum -q check-update || [ $? -eq 100 ]
  yum -q -y groupinstall "Development Tools"
  if [ "$(grep '^CentOS release 6' /etc/centos-release)" ]; then
    # CentOS 6
    yum -q -y install libevent2-devel ncurses-devel
  elif [ "$(grep '^CentOS Linux release 7' /etc/centos-release)" ]; then
    # CentOS 7
    yum -q -y install libevent-devel ncurses-devel which
  elif [ "$(grep '^CentOS Linux release 8' /etc/centos-release)" ]; then
    # CentOS 8
    yum -q -y install libevent-devel ncurses-devel which
  else
    echo "[ERROR] Unknown distribution (seems to be rhel-related one)."
    exit 1
  fi
else
  echo "[ERROR] Unknown distribution."
  exit 1
fi

cd /tmp
git clone --quiet --depth 1 https://github.com/tmux/tmux
cd ./tmux/
./autogen.sh
./configure --prefix=/usr/local
make --quiet
make install
which tmux
tmux -V
