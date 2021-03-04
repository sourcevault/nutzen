reg                  = require "../dist/registry"

{z,noops,print_fail} = reg.com

be                   = require "../dist/main"

p                    = print_fail "test/test1.js"

address = be.required \city
.on \city,be.str
.on \country,be.str.fix \France

V = be.required \name,\age
,\address
.on \address,address
.on \name,be.str
.on \age,be.num

sample =
	*name:"Fred"
		age:30
		address:
			*city:"foocity"
				country:null


ret = V.auth sample

if not (ret.value.address.country is \France)

	p!


















