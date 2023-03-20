proj  = \guard

name  = \test

#-------------------------------------------------------------------------------

# BOILER PLATE

pkg = require \../../dist/types/main

{internal,types,guard} = pkg

{l,z,c,binapi,print_fail,create_stack} = internal

be = types

fail = print_fail "test/#{proj}/#{name}.js"

# # -----------------------------------------------------------------------------


bothNum = (x,y) -> (((typeof x) is "number") and ((typeof y) is "number"))

argE    = -> z "only accepts 2 arugument"

typeE   = -> z "argument type has to be number"

add = (x,y) -> x + y

