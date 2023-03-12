pkg = require \../../dist/types/main

{utils,types} = pkg

{z,l,R,j,print_fail} = utils

be = types

p = print_fail "test/types/test5.js"

# ----------------------------------

T = (x) -> true

F = (x)  -> [false,\foobar]

V = be.arr.map be.str.err 'not string'
.or be.num
.or be.obj
.and F

von = V.auth [1,2]

z von

# if not (von.message[0] is "not array")
#   p 1




