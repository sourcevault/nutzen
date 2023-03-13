pkg = require \../../dist/types/main

{utils,types} = pkg

{z,l,R,j,print_fail} = utils

be = types

N = be.num.tap do
  (x,index,accum) ->
    accum.push "a:" + x

V = {}

# fin_ret = (...,fin)-> fin

V.0 = be.arr.forEach [0,1,1],N

# V.1 = be.arr.forEach [2,1,1],N

# V.2 = be.arr.forEach [0,-1,1],N

# V.3 = be.arr.forEach [-1,0,-1],N

# V.4 = be.arr.forEach [-1,0,1],N

# for name,val of V

#   V[name] = val.cont(fin_ret).wrap

# r1 = V.0 [0,1,2,3],[]

# z r1



# r2 = V.1 [0,1,2,3],[]

# r3 = V.2 [0,1,2,3],[]

# r4 = V.3 [0,1,2,3],[]

# r5 = V.4 [0,1,2,3],[]


# # []
# # [ 'a:0', 'a:1', 'a:2', 'a:3' ]
# # [ 'a:3', 'a:2', 'a:1', 'a:0' ]
# # []

# l R.equals r1,[ 'a:0', 'a:1' ]


# F = (data)->

#   if data is 2 then return true

#   false

# V = be.arr

# .onor [0,1],F


# V.auth [1,2,3]


# V = be.arr

# .try

# .on 0,be.num

# .err (arr) -> \num
# .err (arr) -> \num1
# .fix (x) -> x

# .try

# .on 1,be.str

# .err (arr) -> \str
# .err (arr) -> \str1

# augh = V.auth []

# l "---- V.auth [] ----"

# l augh

# augh = V.auth [1]

# l "---- V.auth [1] ----"

# l augh

# augh = V.auth ['s']

# l "---- V.auth ['s'] ----"

# l augh


# V = be.obj

# .on \remote,be.arr

# .on [\remotefold,\remotehost],be.not.undefnull


# test =
#   remote:['ls']
#   remotefold:\code

#   # remotehost: \123.43.54.1

# out = V.auth test

# z "---V.out---"

# z out


