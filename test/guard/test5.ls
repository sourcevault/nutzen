proj  = \guard

name  = \test5

#-------------------------------------------------------------------------------

# BOILER PLATE

path = (name) -> "../../dist/#{name}/main"

oxo   = require path \guard

com   = require path \utils

{l,zj,z,c,binapi,print_fail,create_stack,R} = com

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------

# bothNum = (x,y) -> (((typeof x) is "number") and ((typeof y) is "number"))

# argE    = -> z "only accepts 2 arugument"

# typeE   = -> z "argument type has to be number"

# add = (x,y) -> x + y

# hop = hoplon








