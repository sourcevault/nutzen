pkg = require \../../dist/types/main

{utils,types} = pkg

{l,z,c,binapi,print_fail,create_stack} = utils

be = types

fail = print_fail "test/utils/test1.js"

# ------- ----------------------------------------------------------------------------------

# <| TEST 6 |>

# complex monadic api example from readme

get = ([old,num],key) -> [true,[key,num]]

lopo = (state) -> binapi F6,get,state

F6 = ([key,x],args) ->

  [y] = args

  switch key
  | null       => lopo ["init",y]
  | "add"      => lopo ["chain",x + y]
  | "multiply" => lopo ["chain",x*y]
  | "ret"      => x
  | otherwise  =>
      fail 6


try

  compute = lopo [null]

  out = compute 5
  .add 5
  .multiply 10
  .ret!

  if not (out is 100)

    fail 6

catch E
  l E
  fail 6


