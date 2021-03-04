reg = require "../dist/registry"

be = require "../dist/main"

{com,print} = reg

{z,l,hop,print_fail} = com

p = print_fail "test/test6.js"

T = (x) -> true

F = (x)  -> [false,\foobar]

V = be.restricted [0,1]

ret = V.auth [\a,\b,\c]

if not (ret.message[0] is \:res)

  p ".restricted message is not accurate."

