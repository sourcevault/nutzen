com = require \../../dist/utils/main

{l,zj,z,c,binapi,print_fail,create_stack} = com

{l,z,binapi} = com

fail = print_fail "test/utils/test2.js"

# ------------------------------------------------------------------------------------------

main = ->

getter = (state,key) -> [true,state.concat key]

log = (state) ->

  chain = state.join(' | ')

  "( " + chain + " )"

test = binapi(main,getter,[],log)

tsf = test.sync.flip




