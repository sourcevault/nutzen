reg                  = require "../dist/registry"

{z,noops,print_fail} = reg.com

be = require "../dist/main"

p = print_fail "test/test2.js"

G7 = new Set ["USA","EU","UK","Japan","Italy","Germany","France"]

valG7 = (s)->

	if (G7.has s) then return true

	else return [false,"not in G7"]

isG7 = be.str.and valG7

ret1 = isG7.auth "UK"

ret2 = isG7.auth "Spain"


if not (ret1.value is \UK)

	p!



if not (ret2.message is "not in G7")

	p!

if (ret2.value is undefined)

	p ".value has not been passed to {..error:true..}."





