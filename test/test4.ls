reg = require "../dist/registry"

require "../dist/main" # [..load main.js ..]

# ------- ----------------------------------------------------------------------------------

{com,print,hoplon} = reg

{z,l,print_fail,R} = com

p = print_fail 'test4.js'

hop = hoplon

# ------- ----------------------------------------------------------------------------------

type_num = (x) ->
  switch x
  |  \integer => \int
  |  \boolean => \bool
  |  otherwise => false


type_str = (x) ->
  switch x
  |  \string => \str
  |  otherwise => false


V = hop.ar 1,
  hop.ma do
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
