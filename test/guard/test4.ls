proj  = \guard

name  = \test4

#-------------------------------------------------------------------------------

# BOILER PLATE

path = (name) -> "../../dist/#{name}/main"

oxo   = require path \guard

com   = require path \utils

{l,zj,z,c,binapi,print_fail,create_stack,R} = com

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


V = oxo.ar 1,
  oxo.ma do
    type_num
    (x) -> x
  .def ["FROM UDEF"]
.def null

out = V \integer

if not (out is \int)
  p!

out = V null

if not ((R.type out) is \Array)
  p!

if not (out[0] is "FROM UDEF")
  p!
