#!/bin/bash

set -xue

cmake . -Bbuild-dir -DVERSION:STRING="${TRAVIS_TAG}-build-${TRAVIS_BUILD_NUMBER}"
cmake --build build-dir 

set +xue
