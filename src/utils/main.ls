# --------------------------------------------------------------------------------------

vendor           = require "./vendor"

l                = console.log

flat             = vendor.flat

advanced_pad     = vendor.pad

deep_freeze      = vendor.deepFreeze

alpha_sort       = vendor.alpha_sort

R                = require "ramda"

esp              = require "error-stack-parser"

_jspc            = vendor.stringify


if (typeof window is "undefined") and (typeof module is "object")

  util = require \util

  util_inspect_custom = util.inspect.custom

else

  util_inspect_custom = Symbol.for \nodejs.util.inspect.custom

uic = util_inspect_custom

# --------------------------------------------------------------------------------------

noop                      = !->

noop[util_inspect_custom] = -> @[util_inspect_custom]

# --------------------------------------------------------------------------------------

jspc_def = {maxLength:30,margins:true}

jspc = (obj,opt) ->

  if opt is undefined
    opt = jspc_def
  else
    opt = R.mergeRight jspc_def,opt

  _jspc obj,opt

z = -> console.log ...arguments

jspc.r = R.curry (opt,obj) -> jspc obj,opt

z.j = (obj)-> console.log (jspc obj)

z.n = ->

  args = ['\n',...arguments,'\n']

  console.log ...args

z.p = (obj)->

  cont = true

  disp = []

  current = obj

  while cont

    disp.push obj

    cp = obj.__proto__
     
    if cp is null

      cont = false

    obj = cp

  disp.pop!

  console.dir disp

# --------------------------------------------------------------------------------------

loopfault = ->

  loopError  = ->

  apply = -> new Proxy(loopError,{apply:apply,get:get})
  get   = -> new Proxy(loopError,{apply:apply,get:get})

  new Proxy(loopError,{apply:apply,get:get})

# --------------------------------------------------------------------------------------

ansi_wrap = (a,b) -> (msg) -> '\u001b['+ a + 'm' + msg + '\u001b[' + b + 'm'

cc = {}
  ..ok    = (txt) -> "\x1B[38;5;2m#{txt}\x1B[39m"
  ..er1   = (txt) -> "\x1B[38;5;3m#{txt}\x1B[39m"
  ..er2   = (txt) -> "\x1B[38;5;13m#{txt}\x1B[39m"
  ..er3   = (txt) -> "\x1B[38;5;1m#{txt}\x1B[39m"
  ..warn  = (txt) -> "\x1B[38;5;11m#{txt}\x1B[39m"
  ..pink  = (txt) -> "\u001b[35m#{txt}\u001b[39m"
  ..blue  = (txt) -> "\x1B[38;5;12m#{txt}\x1B[39m"
  ..white = (txt) -> "\x1B[37m#{txt}\x1B[39m"
  ..grey  = (txt) -> "\x1B[38;5;8m#{txt}\x1B[39m"

c = {}

aj = (func) -> -> func ([...arguments].join "")

for name,func of cc

  c[name] = aj func

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

    # cc = [c.white,c.grey]

    cc = [c.grey,c.grey]

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

print_fail = (filename) -> (message = "") !->

  l do
    "[TEST ERROR] #{filename}:"

  txt = switch typeof message
  | \number   => "\n    failed at TEST NUMBER #{message}\n"
  | \string   => "\n    #{message}\n"
  | otherwise => ""

  l txt

  process.exitCode = 1

wait = (t,f) -> setTimeout f,t

tupnest_recurse = (a,index = 0) ->

  if index is (a.length - 1) then return a[index]

  ot = a[index]

  if (R.type a[index]) is \Array

    [...ot,tupnest_recurse(a,index+1)]

  else 

    [ot,tupnest_recurse(a,index+1)]


tupnest = -> tupnest_recurse arguments,0


tupnest.push = (da,ta)->

  current = da

  cont = true

  while cont

    last_index = current.length - 1

    if (Array.isArray current[last_index])

      current = current[last_index]

    else

      current.push ta

      cont = false

  da

tupnest.concat = (da,ta) ->

  cda = R.clone da

  tupnest.push cda,ta

# binapi.ls

generic_log = (state) -> state

veri = (arglen,fun,uget,state,ulog) ->

  switch arglen
  | 0 =>
    l "[argument.error] top level function did not recieve any argument."
    return null

  switch typeof fun
  | \function => 0
  | otherwise =>
    l "[argument.type.error] second argument can only be a function"
    return null

  switch typeof uget
  | \function => 0
  | otherwise =>
    l "[argument.type.error] third argument can only be a function"
    return null

  switch typeof ulog
  | \function => ulog
  | otherwise => generic_log

# -----------------------------------------------

ap = (__,___,args) ->

  @fun @state,args

isA = Array.isArray

get = (__,ukey,___) ->

  switch ukey
  | uic       => return @log @state

  ret = @cache[ukey]

  if ret then return ret

  sortir = @uget @state,ukey

  if isA sortir

    [cont,state] = sortir

    if not cont
      return state
  else

    state = sortir

  data =
   *cache:{}
    log:@log
    fun:@fun
    state:state
    apply:ap
    get:get
    uget:@uget

  P = new Proxy(noop,data)

  @cache[ukey] = P

  return P

pub = (fun,uget,state,ulog) ->

  log = veri arguments.length,fun,uget,state,ulog

  switch log
  | null => return

  data =
    log:log
    fun:fun
    state:state
    uget:uget
    cache:{}
    apply:ap
    get:get

  P = new Proxy(noop,data)

  P

com =
  *z:z
   l:l
   c:c
   R:R
   esp:esp
   lit:lit
   flat:flat
   noop:noop
   wait:wait
   jspc:jspc
   binapi:pub
   tupnest:tupnest
   pad:advanced_pad
   loopError:loopfault
   print_fail:print_fail
   alpha_sort:alpha_sort
   uic:util_inspect_custom
   deep_freeze:deep_freeze
   create_stack:create_stack

com.version = \__VERSION__

com.homepage = \https://github.com/sourcevault/hoplon#readme.md


ht = (da)-> @self = da; @

ht.is_def = new Set!

ht.is_ins = (F) ->

  (F instanceof ht) or (ht.is_def.has F)

# ------------------------------------------------------------------

ext =
  com:Object.freeze com
  htypes:ht


module.exports = ext


