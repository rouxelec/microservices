#!/bin/bash
for i in $(seq 1 1000); do
    echo $i
    curl $1
done