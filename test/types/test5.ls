{utils,types} = require \../../dist/main

{z,l,R,j,print_fail} = utils

be = types

p = print_fail "test/types/test5.js"

# ----------------------------------

T = (x) -> true

F = (x)  -> [false,\foobar]

V = be.arr.map be.str
.or be.str
.or be.obj
.and F

ret = V.auth null

if not (ret.message[0] is "not array")
  p!




