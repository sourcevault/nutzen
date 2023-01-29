{utils,types} = require \../../dist/main

{z,l,R,j,print_fail} = utils

be = types

p = print_fail "test/types/test7.js"

# V = be.arr

# .err ["first error"]

# .or do

#   be -> [false,\initial]

#   .err (stuff) ->

#     ["second error"]

# .err (msg,path)->

#   z msg,path

#   message:\ac_input,path:[]


# .or be.num.err(["this is an array"]).or be.obj
# .err ['string here']
# .or (be -> [false,\foobar]).err ['college']

# .or be -> [false,\foorbar1]

# .or be.arr.err ['error message',1]





