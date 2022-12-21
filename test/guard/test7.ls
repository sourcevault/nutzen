proj  = \guard

name  = \test7

#-------------------------------------------------------------------------------

# BOILER PLATE

path = (name) -> "../../dist/#{name}/main"

xop   = require path \guard

# be    = require path \types

com   = require path \utils

{l,zj,z,c,binapi,print_fail,create_stack,R} = com

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------

xop = xop.debug

# vo = xop.arwh 3,-> true,-> 'hello world'

A =
  1: -> 4
   # *-> false
   #  3
   # *-> true
   #  4


    
  # 0:
  #   -> false
  #   -> "corruption"



