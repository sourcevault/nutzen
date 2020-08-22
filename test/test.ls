reg = require "../dist/registry"

require "../dist/main" # [..load main.js ..]

# ------- ----------------------------------------------------------------------------------

{com,print,hoplon} = reg

{z,l} = com

p = print.fail 'test.js'

# ------- ----------------------------------------------------------------------------------

bothNum = (x,y) -> (((typeof x) is "number") and ((typeof y) is "number"))

argE = -> z "only accepts 2 arugument"

typeE = -> z "argument type has to be number"

add = (x,y) -> x + y

hop = hoplon

adder = hoplon
.whn bothNum,typeE
.arn 2,argE
.ar 2,add

if not ((adder.pipe 2,4) is 6)
  p!

w = adder.wrap!

if not ((w 2,4) is 6)
  p!





