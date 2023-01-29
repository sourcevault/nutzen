proj  = \guard

name  = \test

#-------------------------------------------------------------------------------

# BOILER PLATE

{utils,types,guard} = require \../../dist/main

{l,z,c,binapi,print_fail,create_stack} = utils

be = types

fail = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------


bothNum = (x,y) -> (((typeof x) is "number") and ((typeof y) is "number"))

argE    = -> z "only accepts 2 arugument"

typeE   = -> z "argument type has to be number"

add = (x,y) -> x + y

