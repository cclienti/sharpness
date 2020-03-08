#/bin/bash

set -ex
set -o pipefail

CFLAGS="${CFLAGS} -Wall -Winline -O2 -g -D_FILE_OFFSET_BITS=64 -fPIC"

# build static library
make install PREFIX=${PREFIX} CFLAGS="${CFLAGS}"

# build shared library
make -f Makefile-libbz2_so CFLAGS="${CFLAGS}"
ln -s libbz2.so.${PKG_VERSION} libbz2.so
cp -d libbz2.so* ${PREFIX}/lib/
