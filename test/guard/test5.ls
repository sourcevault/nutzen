proj  = \guard

name  = \test5

#-------------------------------------------------------------------------------

# BOILER PLATE

path = (name) -> "../../dist/#{name}/main"

oxo   = require path \guard

be    = require path \types

com   = require path \utils

{l,zj,z,c,binapi,print_fail,create_stack,R} = com

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------

A = be.known.arr.forEach (__,x) -> console.log arguments
