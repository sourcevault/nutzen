proj  = \guard

name  = \test5

#-------------------------------------------------------------------------------

# BOILER PLATE

{internal,types,guard} = require \../../dist/types/main

{l,z,c,binapi,print_fail,create_stack,R} = internal

be = types

xop = guard

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------

# V = xop.arnwhn do
#   1
#   -> false
#   -> \arnwhn
# .def!


# if (V!) isnt \arnwhn

#   pf "normal 3 argument .arnwhn doesn't work"

A =
  0:
   *-> true
    -> \A:0
  1: -> \A:1

V = xop.arwh A
.def \central

if V! isnt \A:0

  pf ".arwh object notation error "

if (V 1) isnt \A:1

  pf ".arwh object notation error - direct value"


V1 = xop.arwhn A
.def \binto


if (V1 4) isnt \A:1

  pf ".arwhn object function not working"

V = xop.arnwh 1,-> true,34
.def \central

if V! isnt 34

  pf ".arnwh normal function not working"

V = xop.cap do
  -> [null]
  -> arguments[0][0]
.def!


if (V! isnt null)

  pf ".cap normie function not working"

A =
  0:
   -> 1

V = xop.arcap A
.def!

if (V! isnt 1)

  pf ".arcap object notation, single function not working."

A =
  0:
   -> false
   -> arguments

V = xop.arcap A
.def 53

if (V! isnt 53)

  pf ".arcap object notation, not rejection ( 2 arg )."

A =
  2:
   -> true
   -> arguments[2]

V = xop.arcap A
.def 53

tuo = V 56,8

if (tuo isnt 8)

  pf ".arcap object notation, second argument not moved ( 2 arg )."











