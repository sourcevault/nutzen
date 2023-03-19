pkg = require \../../dist/types/main

{utils,types} = pkg

{z,l,R,j,print_fail} = utils

be = types

p = print_fail "test/types/test5.js"

# ----------------------------------

T = (x) -> true

F = (x)  -> [false,\foobar]

V = be.arr.map be.str

.or be.num.or be.str
.or be.obj
.and F

von = V.auth null

if not (von.message[0][0] is "not array")
  p 1

bvon = be.flatro von.message

msg = bvon[0][1][0]

if msg isnt "not array"
  p ".flatro algo has problem"



