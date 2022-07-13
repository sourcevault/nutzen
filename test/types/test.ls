com = require \../../dist/utils/main

{z,l,R,j,zj,print_fail} = com

be = require \../../dist/types/main

# V = be.num
# .or be.str
# .err (msg) ->

#   z be.flatro msg

# V.auth void

# z be.arr 1


V = be.known.obj
.on do
  *[
    [\and,\remote,be.num]
    [\alt,[\remotefold,\remotehost],(be.undefnull.cont 45)]
    [\and,\foobar,be.num]
   ]


sample_data =
  *remote: 1
   remotfold: 3
   foobar: 4
