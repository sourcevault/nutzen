#!/bin/bash
lsc -bco . src/gulpfile.ls
gulp default

for i in test/*/*.js;do
    node $i || exit 1
    echo $i
  done