#!/bin/bash

set -ex
set -o pipefail

chmod +x config
mkdir obj
cd obj
../config --prefix=${PREFIX} --openssldir=${PREFIX}
make -j${CPU_COUNT}
make install_sw
