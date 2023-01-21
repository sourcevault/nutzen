proj  = \guard

name  = \test7

#-------------------------------------------------------------------------------

# BOILER PLATE

path = (name) -> "../../dist/#{name}/main"

guard = require path \guard

# be    = require path \types

# xop = guard

xop = guard

com   = require path \utils

{l,zj,z,c,binapi,print_fail,create_stack,R} = com

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------

# xop = guard.unary.debug.immutable

#   -> z 'hello world'
#   -> z 'done'

F = -> false
T = -> true

binto = {}

binto.1  = -> z 'binto_1'
binto.2  = -> z 'binto_2'


ob =
  1:
   *F
    binto.1
   *T
    binto.2

# G = xop.arcap do
#   1
#   -> true
#   null
#   -> z 'binto'
# .def!


# V = xop.arcap ob

# .def!

# rfalse  =-> true

# longview = -> z 'longview'


# V 1

# G 1





