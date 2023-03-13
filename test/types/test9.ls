pkg = require \../../dist/types/main

{utils,types} = pkg

{z,l,R,j,print_fail} = utils

be = types

S = JSON.stringify

p = print_fail "test/types/test9.js"


V = be.arr
.err ['hello world']
.err (msg) -> be.flatro msg

von = V.auth null

s = S von.message[0][1]

if s isnt '["hello world"]'

  p 1

V1 = be.arr
.err [\:me,'frostbite']
.err be.flatro

von = V1.auth 1

s = S von.message

if s isnt '[[":me","frostbite"]]'

  p 2