{utils,types} = require \../../dist/main

{z,l,R,j,print_fail} = utils

be = types

p = print_fail "test/types/test4.js"

# ----------------------------------

inn = be.str.or be.num.or (be.obj.on "age",be.num)

main = be.obj.map inn

example =
  \adam : {age:null}
  \charles : 35
  \henry : (age: \foobar)
  \joe : 33

# ret = main.auth example

# V = be.arr.map be.num

# V.auth [1,2,3,null,4],1,2,3,4,5,6,7

# V = be.obj.on \hello,



