#!/bin/sh

./runner.sh iostat &
./runner.sh vmstat &
./runner.sh sar_pagefaults &
./runner.sh mongostat "$@" &
./runner.sh mongotop "$@" &
./runner.sh serverstatus "$@" &
