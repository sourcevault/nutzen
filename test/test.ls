reg = require "../dist/registry"

require "../dist/main" # [..load main.js ..]

#------------------------------------------------------------------------------

wait = (t,f) -> setTimeout f,t

{com,print,hoplon} = reg

hop = hoplon

{z,l,R,c,print_fail} = com

#-------------------------------------------------------------------------------

# bothNum = (x,y) -> (((typeof x) is "number") and ((typeof y) is "number"))

# argE    = -> z "only accepts 2 arugument"

# typeE   = -> z "argument type has to be number"

# add = (x,y) -> x + y

# find the area of circle / square

# z area.square 2 # 6