#!/bin/bash
gulp compile

for i in test/*/*.js;do
    node $i || exit 1
  done