FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update &&\
    apt -yq --no-install-suggests --no-install-recommends install\
        software-properties-common gpg-agent dirmngr wget git make g++ python3-pip &&\
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null &&\
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" &&\
    apt-add-repository -y "ppa:ubuntu-toolchain-r/test" &&\
    apt update &&\
    apt -yq --no-install-suggests --no-install-recommends install cmake gcc-11 g++-11 &&\
    rm -rf /var/lib/apt/lists/*

RUN apt-add-repository -y ppa:mhier/libboost-latest &&\
    echo "deb http://mirror.mxe.cc/repos/apt/ `lsb_release -sc` main" | tee /etc/apt/sources.list.d/mxeapt.list &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C6BF758A33A3A276 &&\
    apt update &&\
    apt -yq --no-install-suggests --no-install-recommends install\
       libboost1.74-dev mxe-i686-w64-mingw32.static-boost mxe-x86-64-w64-mingw32.static-boost &&\
    rm -rf /var/lib/apt/lists/* 


ENV CC=gcc-11
ENV CXX=g++-11

