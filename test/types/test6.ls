pkg = require \../../dist/types/main

{utils,types} = pkg

{z,l,R,j,print_fail} = utils

be = types

p = print_fail "test/types/test6.js"

# ----------------------------------

T = (x) -> true

F = (x)  -> [false,\foobar]

V = be.restricted [0,1]

von = V.auth [\a,\b,\c]

as = JSON.stringify von.message

if not (as is '[":res",[0,1]]')

  p ".restricted message is not accurate."

as = JSON.stringify von.path

if not (as is '["2"]')

  p ".restricted path is not accurate."

