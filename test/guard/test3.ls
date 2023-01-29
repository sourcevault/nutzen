proj  = \guard

name  = \test3

#-------------------------------------------------------------------------------

# BOILER PLATE

{utils,types,guard} = require \../../dist/main

{l,z,c,binapi,print_fail,create_stack,R} = utils

be = types

xop = guard

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------

xop = guard.debug

V_inner = xop
.wh -> true,->true
.def!

V_outer = xop
.wh do
  -> true
  V_inner
.def null


ret = V_outer [1,2,4],[1,2,4]

if not ret
  pf ".wh not working"


