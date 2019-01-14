FROM ubuntu:16.04
MAINTAINER Mitsutaka Takada <mtakada@nces.i.nagoya-u.ac.jp>

RUN apt-get update
ENV PACKAGES build-essential flex bison \
 libpixman-1-0 pkg-config zlib1g-dev libglib2.0-dev libpixman-1-dev \
 curl bzip2 git subversion ruby 

RUN apt-get -y install $PACKAGES

RUN mkdir -p /opt && \
    curl -L -o /opt/gcc-arm-none-eabi.tar.bz2 'https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2?revision=bc2c96c0-14b5-4bb4-9f18-bceb4050fee7?product=GNU%20Arm%20Embedded%20Toolchain,64-bit,,Linux,7-2018-q2-update' && \
    echo '299ebd3f1c2c90930d28ab82e5d8d6c0 */opt/gcc-arm-none-eabi.tar.bz2' | md5sum -c && \
    tar -C /opt -jxf /opt/gcc-arm-none-eabi.tar.bz2 && \
    rm -f /opt/gcc-arm-none-eabi.tar.bz2 && \
    rm -rf /opt/gcc-arm-none-eabi-*/share/doc
    
ENV PATH ${PATH}:/opt/gcc-arm-none-eabi-7-2018-q2-update/bin

WORKDIR /home

RUN git clone https://github.com/TOPPERS-ContributedSoftware/qemu.git && \
    cd qemu && \
    git submodule init && git submodule update --recursive && git checkout stable-2.12_toppers && \
    mkdir build && cd build && \
    ../configure --target-list=arm-softmmu && \
    make && make install && \
    cd /home && rm -rf /home/qemu
