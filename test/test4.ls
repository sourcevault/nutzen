reg = require "../dist/registry"

require "../dist/main" # [..load main.js ..]

# ------- ----------------------------------------------------------------------------------

{com,print,hoplon} = reg

{z,l,binapi} = com

betterTypeof = reg.betterTypeof

p = print.fail 'test4.js'

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
  hop.ma type_str,type_num
  .def ["FROM UDEF"]
.wrap!

out = V "integer"

if not (out is \int)
  p!

out = V null

if not ((betterTypeof out) is \array)
  p!

if not (out[0] is "FROM UDEF")
  p!
