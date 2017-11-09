#!/bin/bash

set -xue

make rebuild -f Makefile.osx VERSION=$TRAVIS_TAG;

set +xue
