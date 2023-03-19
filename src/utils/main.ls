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


version = \__VERSION__

if (typeof window is "undefined") and (typeof module is "object")

  util = require \util

  util_inspect_custom = util.inspect.custom

else

  util_inspect_custom = Symbol.for \nodejs.util.inspect.custom

uic = util_inspect_custom

# --------------------------------------------------------------------------------------

noop                      = !->

noop[uic] = -> @[util_inspect_custom]

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

get_all_protos = (obj) ->

  cont = true

  disp = []

  current = obj

  while cont

    disp.push obj

    cp = obj.__proto__

    if cp in [null,void]

      cont = false

    obj = cp

  disp.pop!

  disp

z.p = (obj)->

  all_proto = get_all_protos obj

  console.dir all_proto

z.d = console.dir

z.pa = (obj) ->

  all_proto = get_all_protos obj

  disp = []

  for cp in all_proto

    props = Object.getOwnPropertyNames cp

    disp.push props

  l disp

  # disp.pop!

  # console.log disp



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
  | \number   => "\n  failed at TEST NUMBER #{message}\n"
  | \string   => "\n  #{message}\n"
  | otherwise => ""

  l txt

  process.exitCode = 1

wait = (t,f) -> setTimeout f,t

tupnest_recurse = (a,index = 0) ->

  if index is (a.length - 1) then return a[index]

  ot = a[index]

  if (R.type ot) is \Array

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

veri_err_str = c.er3 "[hoplon.utils.binapi\##{version}][argument.error]\n"

veri = ->

  arglen = arguments.length

  str = veri_err_str

  if not (arglen in [3,4,5])

    str += c.er1 " top level function did not recieve correct number of argument."

    l str

    return null

  switch arglen
  | 3 =>

    [fun,uget,state] = arguments

    user_map = {}

    # ulog ?

  | 4 =>

    [fun,uget,state,uu_map] = arguments

    switch R.type uu_map
    | \Function =>

      user_map = {}

      ulog = uu_map

    | \Object =>

      user_map = uu_map

      # ulog ?

  | 5 =>

    [fun,uget,state,ulog,user_map] = arguments

  switch typeof fun
  | \function => 0
  | otherwise =>
    str += c.er1 " first argument can only be a function"
    return null

  switch typeof uget
  | \function => 0
  | otherwise =>
    str += c.er1 " second argument can only be a function"
    l str
    return null

  # z typeof ulog

  log = switch typeof ulog
  | \function => ulog
  | otherwise => generic_log

  if not user_map[uic]
    user_map[uic] = log

  user_map

# -----------------------------------------------

ap = (__,___,args) ->

  @fun @state,args

isA = Array.isArray

get = (__,ukey,___) ->

  exists = @user_map[ukey]

  if exists
    return exists @state

  ret = @cache[ukey]

  if ret then return ret

  sortir = @uget @state,ukey

  if isA sortir

    [cont,state] = sortir

    if not cont

      return state

  else

    state = sortir

  handle =
   *cache:{}
    state:state
    apply:ap
    get:get
    fun:@fun
    uget:@uget
    user_map:@user_map

  P = new Proxy(noop,handle)

  @cache[ukey] = P

  return P

pub = (fun,uget,state,ulog,user_map) -> # u stands for user 
  
  user_map = veri.apply null,arguments

  # arguments.length,fun,uget,state,ulog,user_map

  switch user_map
  | null => return

  handle =
    fun:fun
    state:state
    uget:uget
    cache:{}
    apply:ap
    get:get
    user_map:user_map

  P = new Proxy(noop,handle)

  P

com =
  *z:z
   l:l
   c:Object.freeze(c)
   R:Object.freeze(R)
   esp:esp
   lit:lit
   flat:flat
   noop:noop
   wait:wait
   jspc:jspc
   binapi:pub
   tupnest:Object.freeze(tupnest)
   pad:Object.freeze(advanced_pad)
   loopError:loopfault
   print_fail:print_fail
   alpha_sort:alpha_sort
   uic:util_inspect_custom
   deep_freeze:deep_freeze
   create_stack:create_stack

com.version = version

com.homepage = \https://github.com/sourcevault/hoplon#readme.md

symbols = {}

  ..htypes = Symbol \hoplon.types
  ..guard = Symbol \hoplon.guard

symbols = Object.freeze symbols

module.exports = {com,symbols}

# ------------------------------------------------------------------

