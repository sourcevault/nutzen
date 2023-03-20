proj  = \guard

name  = \test1

#-------------------------------------------------------------------------------

# BOILER PLATE

{internal,types,guard} = require \../../dist/types/main

{l,z,c,binapi,print_fail,create_stack,R} = internal

be = types

xop = guard

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------


V1 = xop
.arcap 1,
  -> [false,"hello"]
  -> "world"
  -> void

.def "foobar"

retorn = V1 1

if not (retorn is "world")

  pf ".arcap / normal validator function"

# check if default empty array is provided.

V2 = xop
.arcap 1,
  -> [false]
  ->
  -> []
.def \from_def

txt = V2 1

if not (txt is \from_def)

  pf ".arcap error handling not being done correctly"


V2 = xop
.cap do
  -> [true,5]
  ->
  -> arguments
.def 39

retorn = V2 6

if (retorn[0] isnt 5) or (retorn[1] isnt 6)

  pf ".cap error"











