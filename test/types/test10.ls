pkg = require \../../dist/types/main

{internal,types} = pkg

{z,l,R,j,print_fail} = internal

xop = pkg.guard

be = pkg.types

# V = be.arr

# V.map -> true

V = be.num

.cont -> \n

.alt be.objerr

.wrap

V 1,2

