# HPS Content Wipe Program

The HPS content wipe program is a small program that is invoked by SDM when there is a security breach event detected or during a cold reset. The intention of this program is to clear HPS content, especially in cache. This memory might contain sensitive data.

## How to build
User can build the HPS wipe with two different compilers, which are GCC and ARMCLANG

### GCC compiler 
> $make COMPILER=GCC 

User can specify the CROSS_COMPILE option, since in linaro version 9, the binary name of the compiler changed.
> $make COMPILER=GCC  CROSS_COMPILE=aarch64-linux-gnu-
> $make COMPILER=GCC  CROSS_COMPILE=aarch64-none-linux-gnu-

### ARMCLANG Compiler
> $make COMPILER=ARMCLANG

## To clean
> $make clean COMPILER=GCC
> $make clean COMPILER=ARMCLANG


## Prerequisite
### Compile with GCC
Please download GCC compiler from
https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/aarch64-linux-gnu/

### Compile with ARMCLANG
Please download ARM Development Studio from
https://www.arm.com/

### For Windows user
Please download MSYS2 from
https://www.msys2.org/

### Export Environment
Please export the installation path of the bin folder for the compilers
Examples:

GCC
> export PATH=$PATH:/c/gcc-linaro-7.5.0-2019.12-i686-mingw32_aarch64-linux-gnu/gcc/bin

ARMCLANG
> export PATH=$PATH:/c/Program\ Files/Arm/Development\ Studio\ 2021.0/sw/ARMCompiler6.16/bin
