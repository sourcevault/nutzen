com = require \../../dist/utils/main

{z,l,R,j,zj,print_fail} = com

be = require \../../dist/types/main

p = print_fail "test/types/test4.js"

# ----------------------------------

inn = be.str.or be.num.or (be.obj.on "age",be.num)

main = be.obj.map inn

example =
  \adam : {age:null}
  \charles : 35
  \henry : (age: \foobar)
  \joe : 33

ret = main.auth example