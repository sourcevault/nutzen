com = require \../../dist/utils/main

{z,l,R,j,zj,print_fail} = com

be = require \../../dist/types/main


V = be.arr
.err ['hello world']
.err (msg) ->

  z be.flatro msg

V1 = be.arr
.err [\:me,'frostbite']
.err (msg) ->

  z be.flatro msg


# V.auth null

# V1.auth null
