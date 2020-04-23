#!/bin/bash

set -ex
set -o pipefail

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_PREFIX_PATH=${PREFIX} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
      ..

make VERBOSE=1 -j${CPU_COUNT}
make install
