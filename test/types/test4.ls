pkg = require \../../dist/types/main

{utils,types} = pkg

{z,l,R,j,print_fail} = utils

be = types

p = print_fail "test/types/test4.js"

# ----------------------------------

inn = be.str.or be.num.or (be.obj.on "age",be.num)

main = be.obj.map inn

example =
  \adam :
    age:null
  \charles : 35
  \henry :
    age: \foobar
  \joe : 33

von = main.auth example