reg = require "../dist/registry"

require "../dist/main" # [..load main.js ..]

# ------- ----------------------------------------------------------------------------------

wait = (t,f) -> setTimeout f,t

{com,print,hoplon} = reg

{z,l,R} = com

p = print.fail 'test.js'

# ------- ----------------------------------------------------------------------------------

bothNum = (x,y) -> (((typeof x) is "number") and ((typeof y) is "number"))

argE    = -> z "only accepts 2 arugument"

typeE   = -> z "argument type has to be number"

add = (x,y) -> x + y

hop = hoplon


F1 = hop

.arma do
	1
	-> false
	-> \hello-world
.def \fault

F1 \foo





