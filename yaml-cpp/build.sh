#!/bin/bash

set -ex
set -o pipefail

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DYAML_CPP_BUILD_TESTS=OFF \
      ..
make VERBOSE=1 -j${CPU_COUNT}
make install
