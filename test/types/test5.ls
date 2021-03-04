reg                  = require "../dist/registry"

{z,noops,print_fail} = reg.com

be = require "../dist/main"

p = print_fail "test/test5.js"

T = (x) -> true

F = (x)  -> [false,\foobar]

V = be.arr.map be.str
.or be.str
.or be.obj
.and F

ret = V.auth null

if not (ret.message[0] is "not array")
  p!




