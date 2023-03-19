{utils,types} = require \../../dist/types/main

{l,z,c,binapi,print_fail,create_stack} = utils

be = types

fail = print_fail "test/utils/test2.js"

# ------------------------------------------------------------------------------------------

main = ->

getter = (state,key) -> [true,state.concat key]

log = (state) ->

  chain = state.join(' | ')

  "( " + chain + " )"

test = binapi(main,getter,[],log)

tsf = test.sync.flip




