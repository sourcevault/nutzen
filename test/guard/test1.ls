proj  = \guard

name  = \test1

#-------------------------------------------------------------------------------

# BOILER PLATE

path = (name) -> "../../dist/#{name}/main"

guard = require path \guard

com   = require path \utils

{l,zj,z,c,binapi,print_fail,create_stack,R} = com

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------


V1 = guard
.arpar 1,
  -> [false,"hello"]
  -> "world"
  -> void

.def "foobar"

retorn = V1 1

if not (retorn is "foobar")

  pf ".arpar / normal validator function"

# check if default empty array is provided.

V2 = guard
.arpar 1,
  -> [false]
  ->
  -> []
.def!

empty_array = V2 1

if not ((R.type empty_array) is \Array)

  pf ".arpar error handling not being done correctly"

