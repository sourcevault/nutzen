pkg = require \../../dist/types/main

{utils,types} = pkg

{z,l,R,j,print_fail} = utils

be = types

p = print_fail "test/types/test1.js"

address = be.required \city
.on \city,be.str
.on \country,be.str.fix \France

V = be.required \name,\age,\address
.on \address,address
.on \name,be.str
.on \age,be.num

sample1 =
  *name:"Fred"
   age:30
   address:
     *city:"foocity"
      country:null

von = V.auth sample1

if not (von.value.address.country is \France)

  p!

sample_2 =
  *name:"Fred"
   age:30

von = V.auth sample_2


if not ((von.path[0] is \address) and (von.message[0] is \:req) and (von.message[1][2] is \address))

  p "TEST NUMBER 2 - fault in .required error message."















