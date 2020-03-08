#!/bin/bash

set -ex
set -o pipefail

chmod +x configure
mkdir obj
cd obj
../configure --prefix=${PREFIX} --enable-cxx --enable-fat --host=${HOST}
make -j${CPU_COUNT}
make check -j${CPU_COUNT}
make install
