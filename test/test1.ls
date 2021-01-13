reg = require "../dist/registry"

require "../dist/main" # [..load main.js ..]

#------------------------------------------------------------------------------

{com,print,hoplon}   = reg

{z,l,R,c,print_fail} = com

pf = print_fail "test1.js"

hop = hoplon

V1 = hop
.arpar 1,
  -> [false,"hello"]
  -> "world"
  -> false

.def "foobar"

retorn = V1 1

if not (retorn is "foobar")

  pf ".arpar / normal validator function"


