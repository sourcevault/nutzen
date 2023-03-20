proj  = \guard

name  = \test2

#-------------------------------------------------------------------------------

# BOILER PLATE

{internal,types,guard} = require \../../dist/types/main

{l,z,c,binapi,print_fail,create_stack,R} = internal

be = types

xop = guard

pf = print_fail "test/#{proj}/#{name}.js"

#-------------------------------------------------------------------------------

dum1 = (str)->

  switch str
  | \int => \intger
  | \str => \string

dum2 = (str) ->

  switch str
  | \obj => \object
  | \map => \map

V = xop
.cap do
  dum2,\obj_or_map
.def null

out = V \obj


if (out isnt \obj_or_map)
  pf!