proj  = \guard

name  = \test6

#-------------------------------------------------------------------------------

# BOILER PLATE

path = (name) -> "../../dist/#{name}/main"

xop   = require path \guard

com   = require path \utils

{l,zj,z,c,binapi,print_fail,create_stack,R} = com

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------

bothNum = (x,y) -> (((typeof x) is "number") and ((typeof y) is "number"))

argE    = -> z "only accepts 2 arugument"

typeE   = -> z "argument type has to be number"

add2 = (x,y) -> x + y

add = xop
.arwh do
  2
  -> true
  add2
.def!

ret = add 1,2

if not (ret is 3)

  pf!







