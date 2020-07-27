com = require "../dist/common"
printE = require "../dist/print"
hoplon = require "../dist/main"

# ------- ----------------------------------------------------------------------------------

{z,l} = com

p = printE.fail 'test.js'

bothNum = (x,y) -> (((typeof x) is "number") and ((typeof y) is "number"))

argE = -> z "only accepts 2 arugument"

typeE = -> z "argument type has to be number"

add = (x,y) -> x + y

adder = hoplon
.args_not 2,argE
.when_not bothNum,typeE
.args 2,add

if not ((adder 2,4) is 6)
  p!
