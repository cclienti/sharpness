#!/bin/bash

set -ex
set -o pipefail

cd source

chmod +x configure install-sh

# export LD_LIBRARY_PATH=${PREFIX}/${HOST}/lib:${LD_LIBRARY_PATH}

./configure --prefix="${PREFIX}"  \
            --build=${BUILD}      \
            --host=${HOST}        \
            --disable-samples     \
            --disable-extras      \
            --disable-layout      \
            --disable-tests       \
            "${EXTRA_OPTS}"

make -j${CPU_COUNT} ${VERBOSE_CM}
make check
make install

rm -rf ${PREFIX}/sbin
