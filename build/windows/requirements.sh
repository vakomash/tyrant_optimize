#!/bin/bash

set -xue

sudo add-apt-repository -y ppa:mhier/libboost-latest
sudo apt-get update

echo "deb http://mirror.mxe.cc/repos/apt/ trusty main" \
    | sudo tee /etc/apt/sources.list.d/mxeapt.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C6BF758A33A3A276

sudo apt-get update
#Linux
sudo apt-cache search libboost
sudo apt-get --yes install \
    g++ make cmake \
    libboost1.68-dev \
#Windows
MXE_TARGET=i686-w64-mingw32.static
MXE2_TARGET=$(echo "$MXE_TARGET" | sed 's/_/-/g')
sudo apt-get --yes install \
    mxe-${MXE2_TARGET}-boost


MXE_TARGET=x86-64-w64-mingw32.static

MXE2_TARGET=$(echo "$MXE_TARGET" | sed 's/_/-/g')
sudo apt-get --yes install \
    mxe-${MXE2_TARGET}-boost

#Coveralls
pip install --user cpp-coveralls

set +xue
