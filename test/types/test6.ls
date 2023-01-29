{utils,types} = require \../../dist/main

{z,l,R,j,print_fail} = utils

be = types

p = print_fail "test/types/test6.js"

# ----------------------------------

T = (x) -> true

F = (x)  -> [false,\foobar]

V = be.restricted [0,1]

ret = V.auth [\a,\b,\c]

if not (ret.message[0] is \:res)

  p ".restricted message is not accurate."

