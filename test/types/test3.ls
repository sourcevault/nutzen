pkg = require \../../dist/types/main

{internal,types} = pkg

{z,l,R,j,print_fail} = internal

be = types

p = print_fail "test/types/test3.js"

# ----------------------------------


inner = be.arr.or be.num

SA = be.str.or inner

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




