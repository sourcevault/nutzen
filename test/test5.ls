reg = require "../dist/registry"

require "../dist/main" # [..load main.js ..]

Benchmark = require "benchmark"

suite = new Benchmark.Suite

wait = (t,f) -> setTimeout f,t

{com,print,hoplon} = reg

{z,l,binapi,R} = com

betterTypeof = reg.betterTypeof

p = print.fail 'test5.js'

hop = hoplon

# ------- ---------------------------------------------

type_num = (x) ->

  switch x
  |  \integer => 0
  |  \boolean => 1
  |  otherwise => false


type_str = (x) ->

  switch x
  |  \string => 3
  |  otherwise => false


V = hop.ar 1, do
  hop.ma do
    type_str
    type_num
  .def 4

# ------- -----------------------------------------------

A = [\integer,\boolean,\bill,\string,\obama,\arena]

W = V.wrap!

<- wait 500

suite
.add \pipe,->

  I = 0

  for K from 0 to 100

    I += V.pipe A[Math.round((A.length - 1)*Math.random!)]

.add \wrap,->

  I = 0

  for K from 0 to 100

    I += W A[Math.round((A.length - 1)*Math.random!)]


.on \cycle, (e)-> l String e.target

# .run!

