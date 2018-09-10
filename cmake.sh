#!/bin/bash
export TRAVIS_TAG=TMPDebug
export TUO_PLATFORM=windowsXX
export TUO_FILE_32=tuo-x86.exe
export TUO_FILE_64=tuo.exe
export TUO_FILE_32_DEBUG=tuo-x86-debug.exe
export TUO_FILE_64_DEBUG=tuo-debug.exe
export TUO_TARGET=windows
./build/${TUO_TARGET}/build.sh
