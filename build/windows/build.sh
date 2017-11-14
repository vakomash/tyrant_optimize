#!/bin/bash

set -xue

MXE_DIR=/usr/lib/mxe

MXE_TARGET=i686-w64-mingw32.static

${MXE_DIR}/usr/bin/${MXE_TARGET}-cmake . -Bbuild-dir32 -DVERSION:STRING="${TRAVIS_TAG}"
cmake --build build-dir32 

mv build-dir32/tuo.exe $TUO_FILE_32

MXE_TARGET=x86_64-w64-mingw32.static

${MXE_DIR}/usr/bin/${MXE_TARGET}-cmake . -Bbuild-dir64 -DVERSION:STRING="${TRAVIS_TAG}"
cmake --build build-dir64 

mv build-dir64/tuo.exe $TUO_FILE_64

set +xue
