#!/bin/bash

set -ex
set -o pipefail

cd build/cmake
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_BUILD_TYPE=Release \
      ..
make VERBOSE=1 -j${CPU_COUNT}
make install
