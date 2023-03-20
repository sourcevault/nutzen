pkg = require \../../dist/types/main

{internal,types} = pkg

{z,l,R,j,print_fail} = internal

be = types

p = print_fail "test/types/test2.js"

# ----------------------------------

G7 = new Set ["USA","EU","UK","Japan","Italy","Germany","France"]

valG7 = (s)->

  if (G7.has s) then return true

  else return [false,"not in G7"]

isG7 = be.str.and valG7

von1 = isG7.auth "UK"

von2 = isG7.auth "Spain"


if not (von1.value is \UK)

  p 1


if not (von2.message is "not in G7")

  p 2

if (von2.value is undefined)

  p ".value has not been passed to {..error:true..}."




