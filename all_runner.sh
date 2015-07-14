#!/bin/sh

./runner.sh iostat &
./runner.sh mongotop &
./runner.sh mongostat &
./runner.sh vmstat &
./runner.sh sar_pagefault &
./runner.sh serverstatus &
