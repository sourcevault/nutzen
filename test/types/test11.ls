pkg = require \../../dist/types/main

{utils,types} = pkg

{z,l,R,j,print_fail} = utils

p = print_fail "test/types/test11.js"

be = types

S = JSON.stringify

N = be.num.tap do
  (x,index,accum) ->
    accum.push "a:" + x

V = {}

fin_ret = (...,fin)-> fin

V.0 = be.arr.forEach [0,1,1],N

V.1 = be.arr.forEach [2,1,1],N

V.2 = be.arr.forEach [0,-1,1],N

V.3 = be.arr.forEach [-1,0,-1],N

V.4 = be.arr.forEach [-1,0,1],N

for name,val of V

  V[name] = val.cont(fin_ret).wrap

r1 = V.0 [0,1,2,3],[]

von = S r1

if (von isnt '["a:0","a:1"]')

  p "TEST NUMBER 1."

r2 = V.1 [0,1,2,3],[]

von = S r2

if von isnt '[]'

  p "TEST NUMBER 2."

r3 = V.2 [0,1,2,3],[]

von = S r3

if von isnt '["a:0","a:1","a:2","a:3"]'

  p "TEST NUMBER 3."

r4 = V.3 [0,1,2,3],[]

von = S r4

if von isnt '["a:3","a:2","a:1","a:0"]'

  p "TEST NUMBER 4."


V = be.arr

.try

.on 0,be.num

.err (arr) -> \num
.err (arr) -> \num1

.try

.on 0,be.str

.err (arr) -> \str
.err (arr) -> \str1

r5 = V.auth []

von = S r5.message

if von isnt '["str1","num1"]'

  p "TEST NUMBER 5."

von = V.auth [1]

if not von.continue

  p "TEST NUMBER 6."

von = V.auth ['s']

if not von.continue

  p "TEST NUMBER 7."



