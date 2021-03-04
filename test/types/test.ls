reg = require "../dist/registry"

valleydate = require "../dist/main"

{com,print} = reg

{z,l,hop,R,j,zj,print_fail} = com

p = print_fail "test/test.js"

be = valleydate

T = (x) -> true

F = (x)  -> [false,\foobar]

data =
  *foo:
    bar:"hello world"


# V = be -> [false,\first]
# .or (be -> [false,\second]).or be -> [false,\third]
# .or be.obj
# .err be.flatato

# z V.auth 1

# z (be.obj.on \foo, ->)

# z be.str.and ->

# zj (V.auth []).message

# .and 1

# V = be.obj.on do
#   \foo
#   be.obj.on do
#     \bar
#     be.num.cont (x,a,b,c,d) ->
#       z "first: ",a,b,c,d
#       x
#   .on \bar, be.str.and (x,j,k) ->
#     z "second: ",j,k
#     true
# .on [\foo,\bar] do
#   (val,j,k) ->

#     z j,k

#     true

# V.auth {foo:{bar:1}},[\data],[\file]


# V = be.required [\remotehost,\remotefold]

# .on [\remotehost,\remotefold],be.str

# .or do
#   be.bool.or be.undef.err ["data"]
#   # .err ([__,b]) -> b

# .err (msg) ->

#   j msg