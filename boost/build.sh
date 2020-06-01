#!/bin/bash

set -ex
set -o pipefail

PYVER=$(python -c "import sys; sys.stdout.write('{}.{}'.format(sys.version_info.major, sys.version_info.minor))")

TOOLSET="gcc"
INCLUDE_PATH="${PREFIX}/include"
LIBRARY_PATH="${PREFIX}/lib"
CXXFLAGS="${CXXFLAGS} -fPIC"
LINKFLAGS="${LINKFLAGS} -L${LIBRARY_PATH}"

cat <<EOF > ${SRC_DIR}/tools/build/src/user-config.jam
using ${TOOLSET} : : ${CXX} ;
using python : ${PYVER} : ${PREFIX}/bin/python${PYVER} : ${PREFIX}/include/python${PYVER} : ${PREFIX}/lib ;
EOF

./bootstrap.sh \
    --prefix="${PREFIX}" 2>&1 | tee ~/boost.log

./b2 -j${CPU_COUNT} \
     toolset="${TOOLSET}" \
     link=static,shared \
     threading=multi \
     variant=release \
     python=${PYVER} \
     toolset=${TOOLSET} \
     include="${INCLUDE_PATH}" \
     cxxflags="${CXXFLAGS}" \
     linkflags="${LINKFLAGS}" \
     --layout=system \
     install 2>&1 | tee -a ~/boost.log
