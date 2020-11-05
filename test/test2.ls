reg = require "../dist/registry"

require "../dist/main" # [..load main.js ..]

# ------- ----------------------------------------------------------------------------------

{com,print,hoplon} = reg

{z,l} = com

p = print.fail 'test2.js'

hop = hoplon

# -----------------------------------------------------------------------------------------

dum1 = (str)->

  switch str
  | \int => \intger
  | \str => \string

dum2 = (str) ->

  switch str
  | \obj => \object
  | \map => \map

V = hop
.ma do
  dum2,\obj_or_map
.def null

out = V \obj

if not (out is \obj_or_map)
  p!

