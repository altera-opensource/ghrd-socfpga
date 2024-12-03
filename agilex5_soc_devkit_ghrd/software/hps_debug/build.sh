#! /bin/bash

set -e

CROSS_COMPILE_VERSION_NUM=11.2-2022.02
CROSS_COMPILE_FILENAME=gcc-arm-$CROSS_COMPILE_VERSION_NUM-x86_64-aarch64-none-linux-gnu


if [ ! -d "gcc-arm" ]; then
    # Download the ARM Toolchain
    wget https://developer.arm.com/-/media/Files/downloads/gnu/11.2-2022.02/binrel/$CROSS_COMPILE_FILENAME.tar.xz

    # Unpack the ARM Toolchain
    tar xf $CROSS_COMPILE_FILENAME.tar.xz
    rm -f $CROSS_COMPILE_FILENAME.tar.xz
    mv $CROSS_COMPILE_FILENAME gcc-arm
fi

# Set required environment variables
export PATH=`pwd`/gcc-arm/bin:$PATH
export ARCH=arm64
export CROSS_COMPILE=aarch64-none-linux-gnu-

# Build the HPS Debug application
make
