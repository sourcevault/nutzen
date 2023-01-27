proj  = \guard

name  = \test

#-------------------------------------------------------------------------------

# BOILER PLATE

path = (name) -> "../../dist/#{name}/main"

guard = require path \guard

{com} = require path \utils

{l,zj,z,c,binapi,print_fail,create_stack} = com

fail = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------


bothNum = (x,y) -> (((typeof x) is "number") and ((typeof y) is "number"))

argE    = -> z "only accepts 2 arugument"

typeE   = -> z "argument type has to be number"

add = (x,y) -> x + y

