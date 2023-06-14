pkg = require \../../dist/types/main

{internal,types} = pkg

{l,z,c,binapi,print_fail,create_stack} = internal

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



