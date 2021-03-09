com = require \../../dist/utils/main

{z,l,R,j,zj,print_fail} = com

be = require \../../dist/types/main

p = print_fail "test/types/test.js"

T = (x) -> true

F = (x)  -> [false,\foobar]

data =
  *foo:
    bar:"hello world"

V = be -> [false,\first]
.or (be -> [false,\second]).or be -> [false,\third]
.or be.obj
.err be.flatato

V.auth 1

# z (be.obj.on \foo, ->)

# z be.str.and ->

# zj (V.auth []).message

V = be.obj.on do
  \foo
  be.obj.on do
    \bar
    be.num.cont (x,a,b,c,d) ->
      # z "first: ",a,b,c,d
      x
  .on \bar, be.str.and (x,j,k) ->
    z "second: ",j,k
    true
.on [\foo,\bar] do
  (val,j,k) ->

    z j,k

    true

V.auth {foo:{bar:1}},[\data],[\file]


V = be.required [\remotehost,\remotefold]

.on [\remotehost,\remotefold],be.str

.or do
  be.bool.or be.undef.err ["data"]
  # .err ([__,b]) -> b

.err (msg) ->

  # j msg