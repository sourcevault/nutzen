reg                  = require "../dist/registry"

{z,noops,print_fail} = reg.com

be = require "../dist/main"

p = print_fail "test/test1.js"

inn = be.str.or be.num.or (be.obj.on "age",be.num)

main = be.obj.map inn

example =
  \adam : {age:null}
  \charles : 35
  \henry : (age: \foobar)
  \joe : 33

ret = main.auth example