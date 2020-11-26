#!/bin/bash

# apply patches
patch -p0 < Makefile.in.patch

# build nDPI project
cd nDPI
sh autogen.sh
./configure
make
cd ..

# build ntopng project
cd ntopng
sh autogen.sh
./configure
make
cd ..

# build fuzzers

