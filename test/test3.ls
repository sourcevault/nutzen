reg = require "../dist/registry"

require "../dist/main" # [..load main.js ..]

# ------- ----------------------------------------------------------------------------------

{com,print,hoplon} = reg

{z,l} = com

p = print.fail 'test3.js'

# ------- ----------------------------------------------------------------------------------

hop = hoplon

V_inner = hop.wh -> true,->true

V_outer = hop
.wh do
  -> true
  V_inner
.wrap!


ret = V_outer [1,2,4],[1,2,4]

if not ret
  p!


