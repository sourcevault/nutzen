pkg = require \../../dist/types/main

{internal,types} = pkg

{l,z,c,binapi,print_fail,create_stack} = internal

be = types

hop = pkg.guard

fail = print_fail "test/utils/test3.js"

# ----------------------------------------------

# show_stack = create_stack 2,[]

# show_stack new Error!

# main = (a,b,c)->

#   l arguments

# getter = (a,b,c) ->

#   l arguments

# big = binapi main,getter,{b:1}

classe = {}

classe.test = hop
.ar do
  *1:-> @

.def!

ins = Object.create classe

ins = Object.assign ins,{color:\blue}

von = ins.test 1

# <| TEST 1 |>

if not (von.color is \blue )

  fail 1
