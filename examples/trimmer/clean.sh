#!/usr/bin/env bash

for dir in */; do
    echo "$dir"
    cd "$dir"
    make clean
    cd ..
done

