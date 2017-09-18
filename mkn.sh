#!/usr/bin/env bash

set -e

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

GIT_URL="https://github.com/gperftools/gperftools/"
GIT_BNC="master"
GIT_OPT="--depth 1"
DIR="gperf"

[ -z "$MKN_MAKE_THREADS" ] && MKN_MAKE_THREADS="$(nproc --all)"

HAS=1
[ ! -d "$CWD/$DIR" ] && HAS=0 && \
    git clone $GIT_OPT $GIT_URL -b $GIT_BNC $DIR --recursive
[ "$HAS" == 1 ] && cd $DIR && \
    git pull origin $GIT_BNC && cd ..;

rm -rf $CWD/inst

pushd $DIR
./autogen.sh
./configure --prefix=$CWD/inst
make -j$MKN_MAKE_THREADS
make dist
make install
popd

echo "Finished successfully"
exit 0
