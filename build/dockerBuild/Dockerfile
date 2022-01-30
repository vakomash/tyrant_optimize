FROM ubuntu:bionic

RUN apt update &&\
    apt -yq --no-install-suggests --no-install-recommends install\
        software-properties-common gpg-agent dirmngr git make cmake g++ python3-pip &&\
    apt-add-repository -y "ppa:ubuntu-toolchain-r/test" &&\
    apt update &&\
    apt -yq --no-install-suggests --no-install-recommends install gcc-7 g++-7 &&\
    rm -rf /var/lib/apt/lists/*

RUN apt-add-repository -y ppa:mhier/libboost-latest &&\
    echo "deb http://mirror.mxe.cc/repos/apt/ `lsb_release -sc` main" | tee /etc/apt/sources.list.d/mxeapt.list &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C6BF758A33A3A276 &&\
    apt update &&\
    apt -yq --no-install-suggests --no-install-recommends install\
       libboost1.68-dev mxe-i686-w64-mingw32.static-boost x86-64-w64-mingw32.static-boost &&\
    rm -rf /var/lib/apt/lists/* 

RUN apt purge --auto-remove -y cmake &&\
    apt update &&\
    apt install -yq wget &&\
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null &&\
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" &&\
    apt update &&\
    apt install -yq cmake

ENV CC=gcc-7
ENV CXX=g++-7

