{utils,types} = require \../../dist/main

{z,l,R,j,print_fail} = utils

be = types

p = print_fail "test/types/test3.js"

# ----------------------------------

SA = be.str.or be.arr.or be.num

main = be.obj.on do
  "chokidar"
  be.obj
  .on "path",SA

ret = main.auth ({chokidar:{}})

try

  if not ((ret.path.join ".") is "chokidar.path")

    p ".path is mangled"

catch

    p "something has gone wrong with .path"




