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

V = hop.arma do
  [1,2]
  (a,x) ->
    z x
    "hello world"
.def!


F1 = hop
.whn bothNum,typeE
.arn 2,argE
.ar 2,add
.def 1

F1 1,2





