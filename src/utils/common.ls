# --------------------------------------------------------------------------------------

vendor           = require "./vendor"

z                = console.log

l                = console.log

flat             = vendor.flat

advanced_pad     = vendor.pad

jspc             = vendor.stringify

deep_freeze      = vendor.deepFreeze

alpha_sort       = vendor.alpha_sort

R                = require "ramda"

esp              = require "error-stack-parser"

if (typeof window is "undefined") and (typeof module is "object")

  util = require \util

  util_inspect_custom = util.inspect.custom

else

  util_inspect_custom = Symbol.for \nodejs.util.inspect.custom

# --------------------------------------------------------------------------------------

noop = !->

noop[util_inspect_custom] = -> @[util_inspect_custom]

j = (x) -> jspc do
  x
  {
    maxLength:30
    margins:true
  }


zj = (x,y)->
  if y
    z y,(j x) # just like j, but shows console.log
  else
    z j x

# --------------------------------------------------------------------------------------

loopfault = ->

  loopError  = ->
  apply = -> new Proxy(loopError,{apply:apply,get:get})
  get   = -> new Proxy(loopError,{apply:apply,get:get})

  new Proxy(loopError,{apply:apply,get:get})

# --------------------------------------------------------------------------------------

c = {}
  ..ok    = (txt) -> "\x1B[38;5;2m#{txt}\x1B[39m"
  ..er1   = (txt) -> "\x1B[38;5;3m#{txt}\x1B[39m"
  ..er2   = (txt) -> "\x1B[38;5;13m#{txt}\x1B[39m"
  ..er3   = (txt) -> "\x1B[38;5;1m#{txt}\x1B[39m"
  ..warn  = (txt) -> "\x1B[38;5;11m#{txt}\x1B[39m"
  ..pink  = (txt) -> "\x1B[38;5;17m#{txt}\x1B[39m"
  ..grey  = (txt) -> "\x1B[38;5;8m#{txt}\x1B[39m"
  ..blue  = (txt) -> "\x1B[38;5;12m#{txt}\x1B[39m"

# --------------------------------------------------------------------------------------

lit = R.pipe do
  R.zipWith (x,f) ->
    switch R.type f
    | \Function => f x
    | otherwise => x
  R.join ""

rm_paths = (ignore) ->

  R.unless do
    R.find (x) -> ((x is \node_modules) or (x in ignore))
    (path) ->
      (path[0] + "/" + path[1]) in do
        [
          "internal/modules"
          "internal/main"
        ]

create_stack = (take_only,paths = [],init_txt) ->

  EMP = rm_paths paths

  (E)->

    E = esp.parse E

    if init_txt
      l init_txt

    disp = []

    for I in E

      {lineNumber,fileName,functionName,columnNumber} = I

      path = fileName.split "/"

      if (EMP path) then continue

      if (functionName is \Object.<anonymous>)

        functionName = ""

      item = lit do
        [
          "  - "
          R.last path
          ":"
          lineNumber
          " "
          functionName
          "\n    "
          fileName + ":"
          lineNumber
          ":" + columnNumber + "\n"
        ]
        [0,c.warn,0,c.er,0,0,0,c.black,c.er,c.black]

      disp.push item

    disp
    |> R.reverse
    |> R.take take_only
    |> R.join "\n"
    |> l

# --------------------------------------------------------------------------------------

print_fail = (filename) -> (message) !->

  l do
    "[TEST ERROR] #{filename}:"

  txt = switch typeof message
  | \number   => "\n    failed at TEST NUMBER #{message}\n"
  | \string   => "\n    #{message}\n"
  | otherwise => ""

  l txt

  process.exitCode = 1


module.exports =
  *z:z
   j:j
   l:l
   R:R
   c:c
   zj:zj
   esp:esp
   lit:lit
   flat:flat
   noop:noop
   pad:advanced_pad
   loopError:loopfault
   print_fail:print_fail
   alpha_sort:alpha_sort
   uic:util_inspect_custom
   deep_freeze:deep_freeze
   create_stack:create_stack