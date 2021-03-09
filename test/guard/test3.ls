proj  = \guard

name  = \test3

#-------------------------------------------------------------------------------

# BOILER PLATE

path = (name) -> "../../dist/#{name}/main"

guard = require path \guard

com   = require path \utils

{l,zj,z,c,binapi,print_fail,create_stack,R} = com

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------

oxo = guard.debug

V_inner = oxo
.wh -> true,->true
.def!

V_outer = oxo
.wh do
  -> true
  V_inner
.def null


ret = V_outer [1,2,4],[1,2,4]

if not ret
  p!


