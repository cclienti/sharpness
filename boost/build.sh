#!/bin/bash

set -ex
set -o pipefail

PYVER=$(python -c "import sys; \
                   major = sys.version_info.major; \
                   minor = sys.version_info.minor; \
                   extra = '' if int(major) >= 3 and int(minor) >= 8 else 'm'; \
                   sys.stdout.write('{}.{}{}'.format(major, minor, extra))")

TOOLSET="gcc"
INCLUDE_PATH="${PREFIX}/include"
LIBRARY_PATH="${PREFIX}/lib"
CXXFLAGS="${CXXFLAGS} -fPIC"
LINKFLAGS="${LINKFLAGS} -L${LIBRARY_PATH}"

cat <<EOF > ${SRC_DIR}/tools/build/src/user-config.jam
using ${TOOLSET} : : ${CXX} ;
using python : ${PYVER} : ${PREFIX}/bin/python${PYVER} : ${PREFIX}/include/python${PYVER}m : ${PREFIX}/lib ;
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
