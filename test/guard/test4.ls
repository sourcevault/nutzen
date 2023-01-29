proj  = \guard

name  = \test4

#-------------------------------------------------------------------------------

# BOILER PLATE

{utils,types,guard} = require \../../dist/main

{l,z,c,binapi,print_fail,create_stack,R} = utils

be = types

xop = guard

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------

type_num = (x) ->
  switch x
  |  \integer => \int
  |  \boolean => \bool
  |  otherwise => false


type_str = (x) ->
  switch x
  |  \string => \str
  |  otherwise => false


V = xop.ar 1,
  xop.cap do
    type_num
    (x) -> x
  .def ["FROM UDEF"]
.def null

out = V \integer

if not (out is \int)
  pf!

out = V null

if ((R.type out) isnt \Array)
  pf ".ar not working"

if (out[0] isnt "FROM UDEF")
  pf!
