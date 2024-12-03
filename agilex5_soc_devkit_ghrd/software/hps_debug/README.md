# HPS Content Wipe Program

The HPS content wipe program is a small program that is invoked by SDM when there is a security breach event detected or during a cold reset. The intention of this program is to clear HPS content, especially in cache. This memory might contain sensitive data. Besides that, this programm also creates a wait loop for the arm debugger to kick in.

## How to build
User can build the HPS wipe by running the build.sh.
The script will automatically download the ARM Toolchain and compile hps_wipe.ihex.

> cd software/hps debug\
> ./build.sh

## Compile manually
If user already have the ARM Toolchain installed, the version can be specified with the CROSS_COMPILE option.
### version 7
> $make CROSS_COMPILE=aarch64-linux-gnu-
### version 9
> $make CROSS_COMPILE=aarch64-none-linux-gnu-

## To clean
> $make clean CROSS_COMPILE=aarch64-linux-gnu-\
> $make clean CROSS_COMPILE=aarch64-none-linux-gnu-

## Build from project dir: agilex5_soc_devkit_ghrd
If ARM Toolchain is included in PATH, the Makefile will detect that, build and inject the hps_wipe.ihex to the sof automatically.\
\
If Toolchain PATH is included and user would like to inject this programm after compiling the sof with quartus GUI, the following can be called at agilex5_soc_devkit_ghrd folder:
> $make debug_sof
