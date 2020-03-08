#/bin/bash

set -ex
set -o pipefail

./configure --prefix=$PREFIX
make -j${CPU_COUNT}
make check
make install
