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


noop                      = !->

noop[util_inspect_custom] = -> @[util_inspect_custom]

# --------------------------------------------------------------------------------------

jdef = {maxLength:30,margins:true}

j = (obj) -> jspc obj,jdef

j.o = R.curry (opt,obj) ->

  if opt is undefined
    opt = jdef
  else
    opt = R.mergeRight jdef,opt

  jspc obj,opt

# just like j, but shows console.log

zj = (obj,y) ->

  if y
    z y,(j obj)
  else
    z j obj

z.n = ->

  args = ['\n--\n',...arguments,'\n--\n']

  console.log ...args

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
  ..white = (txt) -> "\x1B[37m#{txt}\x1B[39m"

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

    if not E

      l "Error: cannot show Error stack without Error object."

      return

    E = esp.parse E

    if init_txt

      l init_txt

    disp = []

    cc = [c.blue,c.grey]

    for data in E

      {lineNumber,fileName,functionName,columnNumber} = data

      path = fileName.split "/"

      if (EMP path) then continue

      if (functionName is \Object.<anonymous>)

        functionName = ""

      item = do
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

      c_item = R.join "",item

      disp.push c_item

    if disp.length is 0 then return

    disp
    |> R.reverse
    |> R.take take_only
    |> (x) ->

      fin = []

      for I from 0 til x.length

        fin.push cc[I%2] x[I]

      fin
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

wait = (t,f) -> setTimeout f,t

ext =
  *z:z
   j:j
   l:l
   c:c
   zj:zj
   esp:esp
   lit:lit
   flat:flat
   noop:noop
   wait:wait
   jspc:jspc
   pad:advanced_pad
   R:Object.freeze R
   loopError:loopfault
   print_fail:print_fail
   alpha_sort:alpha_sort
   uic:util_inspect_custom
   deep_freeze:deep_freeze
   create_stack:create_stack

module.exports = ext


