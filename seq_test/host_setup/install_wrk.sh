#!/bin/sh

cd /usr/local/src
git clone https://github.com/wg/wrk.git wrk && cd wrk
make
cp ./wrk /usr/local/bin
