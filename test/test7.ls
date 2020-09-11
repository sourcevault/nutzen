reg = require "../dist/registry"

require "../dist/main" # [..load main.js ..]

# ------- ----------------------------------------------------------------------------------

{com,print,hoplon} = reg

{z,l} = com

p = print.fail 'test7.js'

# ------- ----------------------------------------------------------------------------------

bothNum = (x,y) -> (((typeof x) is "number") and ((typeof y) is "number"))

argE    = -> z "only accepts 2 arugument"

typeE   = -> z "argument type has to be number"

add = (x,y) -> x + y

hop = hoplon








