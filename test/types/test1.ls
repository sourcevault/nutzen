{utils,types} = require \../../dist/main

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

sample =
  *name:"Fred"
   age:30
   address:
     *city:"foocity"
      country:null


sortir = V.auth sample


if not (sortir.value.address.country is \France)

  p!













