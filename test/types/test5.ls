com = require \../../dist/utils/main

{z,l,R,j,zj,print_fail} = com

be = require \../../dist/types/main

p = print_fail "test/types/test5.js"

# ----------------------------------

T = (x) -> true

F = (x)  -> [false,\foobar]

V = be.arr.map be.str.err [\:a,\not_string]
.or be.str
.or be.obj
.and F

von = V.auth [1,2]

z von

# if not (ret.message[0] is "not array")
#   p!




