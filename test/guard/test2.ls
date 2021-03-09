proj  = \guard

name  = \test2

#-------------------------------------------------------------------------------

# BOILER PLATE

path = (name) -> "../../dist/#{name}/main"

guard = require path \guard

com   = require path \utils

{l,zj,z,c,binapi,print_fail,create_stack,R} = com

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

V = guard
.ma do
  dum2,\obj_or_map
.def null

out = V \obj

if not (out is \obj_or_map)
  p!