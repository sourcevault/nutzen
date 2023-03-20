ext = require "./verify.print.common"

{com,verify,print} = ext

{l,z,R,uic,binapi,loopError} = com

#---------------------------------------------------

resolve = (F,A) ->

  [ftype,f] = F

  switch ftype
  | \f => f.apply void,A
  | \v => f.auth.apply void,A
  | \s => f

unshift_resolve = (F,init,A) -> # when arguments require manipulation

  [ftype,f] = F

  switch ftype
  | \f =>

    switch A.length
    | 1 => f init,A[0]
    | 2 => f init,A[0],A[1]
    | 3 => f init,A[0],A[1],A[2]
    | 0 => f init
    | 4 => f init,A[0],A[1],A[2],A[3]
    | 5 => f init,A[0],A[1],A[2],A[3],A[4]
    | otherwise =>

      mod-arg = [init,...A]

      f ...mod-arg

  | \v =>

    switch A.length
    | 1 => f.auth init,A[0]
    | 2 => f.auth init,A[0],A[1]
    | 3 => f.auth init,A[0],A[1],A[2]
    | 0 => f.auth init
    | 4 => f.auth init,A[0],A[1],A[2],A[3]
    | 5 => f.auth init,A[0],A[1],A[2],A[3],A[4]
    | otherwise =>

      mod-arg = [init,...A]

      f.auth ...mod-arg

  | \s => f

UNDEC = Symbol \undecided

ob = (fn) -> (da,ta)->

  pick = ta[da.arglen]

  if not pick then return UNDEC

  len = pick.length

  I = 0

  do

    ka = pick[I]

    val = fn da,ka

    if val isnt UNDEC then return val

    I++

  while I < len

  return UNDEC

n = (fn) -> (da,ta) ->

  [num,ka] = ta

  if num is da.arglen

    return fn da,ka

  return UNDEC

a = (fn) -> (da,ta) ->

  [spans,ka] = ta

  if spans[da.arglen]

    return fn da,ka

  return UNDEC

core = {}

core.wh = (da,ta) ->

  if ta.length is 1

    [exec] = ta

    return resolve exec,da.arg

  [[vtype,vF],exec] = ta

  switch vtype

  | \f =>

    cont = vF.apply void,da.arg

    if cont

      return resolve exec,da.arg

  | \v =>

    vd = vF.auth da.arg

    if vd.continue

      return resolve exec,vd.value

  UNDEC

core.whn = (da,ta) ->

  if ta.length is 1

    [exec] = ta

    return resolve exec,da.arg

  [[vtype,vF],exec] = ta

  switch vtype

  | \f =>

    cont = vF ...da.arg

    if not cont

      return resolve exec,da.arg

  | \v =>

    vd = vF.auth da.arg

    if vd.error

      return resolve exec,vd.value

  | \b =>

    if not vF

      return resolve exec,da.arg

  UNDEC

# ---aux----

n_n = (fn) -> (da,ta) -> # not num

  [num,ka] = ta

  if num is da.arglen then return UNDEC

  return fn da,ka

n_a = (fn) -> (da,ta) -> # not array

  [spans,ka] = ta

  if spans[da.arglen] then return UNDEC

  return fn da,ka

arn = {}

arn.a = (da,ta) ->

  [spans,exec] = ta

  if spans[da.arglen] then return UNDEC

  return resolve exec,da.arg

arn.n = (da,ta)  ->

  [num,exec] = ta

  if (da.arglen is num) then return UNDEC

  return resolve exec,da.arg

core.arn = (da,ta) -> arn[ta[0]] da,ta[1]

arwhn = {}

arwhn.ob = ob core.whn

arwhn.n = n core.whn

arwhn.a = a core.whn

core.arwhn = (da,ta) -> arwhn[ta[0]] da,ta[1]

arnwh = {}

arnwh.n = n_n core.wh

arnwh.a = n_a core.wh

core.arnwh = (da,ta) ->

  arnwh[ta[0]] da,ta[1]

arnwhn = {}

arnwhn.n = n_n core.whn

arnwhn.a = n_a core.whn

core.arnwhn = (da,ta) -> arnwhn[ta[0]] da,ta[1]

# -----

core.cap = (da,ta) ->

  switch ta.length
  | 3 => core.cap.3 da,ta
  | 2 => core.cap.2 da,ta
  | 1 => resolve ta[0],da.arg

core.cap.2 = (da,ta) ->

  [exec,[vtype,vF]] = ta

  switch vtype

  | \f =>

    ret = vF.apply void,da.arg

    if ret isnt false

      return unshift_resolve exec,ret,da.arg

  | \v => # .types validator

    vd = vF.auth da.arg

    if vd.continue

      return unshift_resolve exec,vd.value,da.arg

    else

      as_obj = (message:vd.message,path:vd.path)

      narg = [as_obj,...da.arg]

      ret = lastview.apply void,narg

      if (ret isnt void) then return ret

  | \b =>

    if vF

      return resolve exec,da.arg

  UNDEC

core.cap.3 = (da,ta) ->

  [exec,[vtype,vF],lastview] = ta

  switch vtype
  | \f =>

    ret = vF.apply void,da.arg

    if isArray ret

      [cont,msg] = ret

      if cont

        return unshift_resolve exec,msg,da.arg

      else

        narg = [msg,...da.arg]

        lvret = lastview.apply void,narg

    else

      if ret

        return resolve exec,da.arg

      else

        lvret = lastview.apply void,da.arg

    if (lvret isnt void) then return lvret

  | \v => # .types validator

    vd = vF.auth da.arg

    if vd.continue

      return unshift_resolve exec,vd.value,da.arg

    else

      as_obj = (message:vd.message,path:vd.path)

      narg = [as_obj,...da.arg]

      ret = lastview.apply void,narg

      if (ret isnt void) then return ret

  | \b =>

    if vF

      return resolve exec,da.arg

    else

      ret = lastview.apply void,da.arg

      if (ret isnt void) then return ret

  UNDEC


arcap = {}

arcap.ob = ob core.cap

arcap.n = n core.cap

arcap.a = a core.cap

core.arcap = (da,ta) -> arcap[ta[0]] da,ta[1]

isArray = Array.isArray

# .arwh  ------------

arwh = {}

arwh.ob = ob core.wh

arwh.n = n core.wh

arwh.a = a core.wh

core.arwh = (da,ta) ->

  arwh[ta[0]] da,ta[1]

# .ar  ------------

ar = {}

ar.ob = (da,ta) ->

  pick = ta[da.arglen]

  if not pick then return UNDEC

  resolve pick,da.arg

ar.n = (da,ta) ->

  [num,exec] = ta

  if num is da.arglen

    return resolve exec,da.arg

  return UNDEC

ar.a = (da,ta) ->

  [spans,exec] = ta

  if spans[da.arglen]

    return resolve exec,da.arg

  return UNDEC

core.ar = (da,ta) ->

  ar[ta[0]] da,ta[1]

tightloop = (state) -> ->

  if state.unary

    first = arguments[0]

    switch R.type first

    | \Arguments,\Array =>

      arglen    = first.length

    | otherwise =>

      print.route [\unary_not_array,[(new Error!),state]]

      return undefined

  else

    arglen    = arguments.length

  I         = 0

  fns       = state.fns

  terminate = fns.length

  da = {arglen:arglen,arg:arguments,state:state}

  while I < terminate

    elemento = fns[I]

    devolver = core[elemento[0]] da,elemento[1]

    if (devolver != UNDEC) then return devolver

    I += 1

  # --------------------------------------------

  def = state.def

  if def then return resolve def,arguments

#---------------------------------------------------

main = (self) -> @self = self; @

main.prototype.clone = ->

  state = @self

  neo = R.mergeRight state,{fns:[...state.fns],str:[...state.str]}

  new main neo

main.prototype[uic] = print.log.proto

handle =
  def:
    fault:void
    ok:void
  fault: void
  ok: void

handle.fault = (state,data,fname) ->

  print.route [\input,[(new Error!),fname,data,state]]

  neo = Object.assign {},state,{fault:[\input,fname,data]}

  new main neo

genfun = (vfun,fname) -> ->

  state = @self

  if state is void

    print.route [\state_undef,[(new Error!),fname]]

    return void

  if state.fault then return @

  out = vfun fname,arguments

  [status,data] = out

  handle[status] state,data,fname

#---------------------------------------------------

handle.ok = (state,data,fname)->

  neo_data = [fname,data]

  if state.str.length is 0

    fns = state.fns.concat [neo_data]

    neo = R.mergeRight state,{fns:fns,str:(state.str.concat fname)}

    new main neo

  else

    state.fns.push neo_data

    state.str.push fname

    new main state

handle.def.fault = -> null

handle.def.fault[uic] = print.log.def_fault

handle.def.ok = (state,data) ->

  neo = R.mergeRight do
    state
    {
      def:data
      str:state.str
    }

  F  = tightloop neo

  if state.debug

    F[uic] = print.log.wrap neo

  F

main.prototype.def =  ->

  state = @self

  if state is undefined

    print.route [\state_undef,[(new Error!),\def]]

    return undefined

  if state.fault then return handle.def.fault

  [___,data] = verify.def arguments

  handle.def.ok state,data

props =
  *\ar
   \wh
   \whn
   \arn
   \cap
   \arwh
   \arcap
   \arwhn
   \arnwh
   \arnwhn

#---------------------------------------------------

R.reduce do

  (ob,prop) ->

    F = verify.getvfun prop

    ob.prototype[prop] = genfun F,prop

    ob

  main
  props

#---------------------------------------------------

cat = {}

cat.opt = new Set [\unary,\debug]

cat.methods = new Set props.concat [\def]

# Set(12) {'cap', 'arcap', 'wh', 'ar', 'whn', 'arn', 'arwh', 'arnwh', 'arwhn', 'arnwhn', 'def'}

getter = (data,key) ->

  # vr -->  [ 'debug' ],[ 'debug', 'unary' ]

  {path,lock,str,sorted_path} = data

  if lock

    print.route [\setting,[(new Error!),\path_locked,sorted_path,key]]

    return null

  if cat.opt.has key

    if (R.includes key,path)

      print.route [\setting,[(new Error!),\already_in_path,sorted_path,key]]

      null

    else

      npath = path.concat key

      copypath = npath.concat!

      sorted = copypath.sort!

      ndata =
       *path:sorted
        lock:false
        str:(sorted.join ".")
        sorted_path:npath

      [true,ndata]

  else if cat.methods.has key

    ndata =
      *path:path
       lock:true
       str:str
       sorted_path:sorted_path
       key:key

    [true,ndata]

  else if (key is \doc)

    print.docstring

  else

    print.route [\setting,[(new Error!),\not_in_opts,sorted_path,key]]

    return null

topcache = {}

init =
  str      :[]
  fns      :[]
  def      :null
  fault    :false
  unary    :false
  debug    :false


entry = (data,args) ->

  if data is null then return loopError!

  str = data.str

  has = topcache[str]

  if has
    return has[data.key] ...args

  {path,lock,key} = data

  ob = {} # {unary:true},{unary:true,immutable:true}
# 
  for ke in path
    ob[ke] = true

  data = Object.assign {},init,ob

  put = new main data

  topcache[str] = put

  put[key] ...args


proto_log = (state)->

  diff = R.difference [\unary,\debug,\def],state.path

  keys = [...props,...diff]

  keys

guard = binapi do
  entry,getter,{path:[],lock:false,sorted_path:[],str:"",key:null}
  print.log.prox
  __proto__:proto_log

link = {}

proto =
  1:(origin) -> -> proto.def ...[origin,...arguments]

  def:!->

    args = arguments

    targets = [args[I] for I from 1 til args.length]

    [origin] = args

    for prop in targets

      prop.prototype = Object.create origin.prototype

link.proto = guard.ar(proto).def(proto.def)

proto_fn =

 1:(origin) -> ->

  args = arguments

  targets = [args[I] for I from 1 til args.length]

  proto_fn.main origin,[args[0],targets]

 2:(origin,fnames) -> ->

  targets = arguments

  proto_fn.main origin,[fnames,targets]

 def:->

  args = arguments

  [origin,fnames] = args

  targets = [args[I] for I from 2 til args.length]

  proto_fn.main origin,[fnames,targets]

 main: (origin,[fnames,targets]) !->

  for N in fnames

    for T in targets

      T.prototype[N] = origin[N]

link.proto_fn = guard.ar(proto_fn).def(proto_fn.def)

pkg = {}

ext.com.link = Object.freeze link

ext.com = Object.freeze ext.com

pkg.guard = guard

pkg.com = ext.com

pkg.symbols = ext.symbols

module.exports = pkg
