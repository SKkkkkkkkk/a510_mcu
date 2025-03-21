#!/bin/bash

# Build the bootloader and app
cd app/bootloader && ./build.sh && cd -
cd app/app && ./build.sh && cd -

# Merge the binaries into the flash.bin file
python3 ./merge.py app/bootloader/build/bootloader.bin app/app/build/app.bin flash.bin