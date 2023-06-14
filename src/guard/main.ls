ext = require "./verify.print.common"

{com,verify,print} = ext

{l,z,R,uic,binapi,loopError} = com

#---------------------------------------------------

resolve = (F,A,cette) ->

  [ftype,f] = F

  switch ftype
  | \f => f.apply cette,A
  | \v => f.auth.apply cette,A
  | \s => f

unshift_resolve = (F,init,A,cette) -> # when arguments require manipulation

  [ftype,f] = F

  switch ftype
  | \f =>

    mod_arg = [init,...A]

    f.apply cette,mod_arg

  | \v =>

    mod_arg = [init,...A]

    f.auth.apply cette,mod_arg

  | \s => f

UNDEC = Symbol \undecided

ob = (fn) -> (da,ta,cette)->

  pick = ta[da.arglen]

  if not pick then return UNDEC

  len = pick.length

  I = 0

  do

    ka = pick[I]

    val = fn da,ka,cette

    if val isnt UNDEC then return val

    I++

  while I < len

  return UNDEC

n = (fn) -> (da,ta,cette) ->

  [num,ka] = ta

  if num is da.arglen

    return fn da,ka,cette

  return UNDEC

a = (fn) -> (da,ta,cette) ->

  [spans,ka] = ta

  if spans[da.arglen]

    return fn da,ka,cette

  return UNDEC

core = {}

core.wh = (da,ta,cette) ->

  if ta.length is 1

    [exec] = ta

    return resolve exec,da.arg,cette

  [[vtype,vF],exec] = ta

  switch vtype

  | \f =>

    cont = vF.apply cette,da.arg

    if cont

      return resolve exec,da.arg,cette

  | \v =>

    vd = vF.auth.apply cette,da.arg

    if vd.continue

      return resolve exec,vd.value,cette

  UNDEC

core.whn = (da,ta,cette) ->

  if ta.length is 1

    [exec] = ta

    return resolve exec,da.arg,cette

  [[vtype,vF],exec] = ta

  switch vtype

  | \f =>

    cont = vF.apply cette,da.arg

    if not cont

      return resolve exec,da.arg,cette

  | \v =>

    vd = vF.auth.apply cette,da.arg

    if vd.error

      return resolve exec,vd.value,cette

  | \b =>

    if not vF

      return resolve exec,da.arg,cette

  UNDEC

# ---aux----

n_n = (fn) -> (da,ta,cette) -> # not num

  [num,ka] = ta

  if num is da.arglen then return UNDEC

  return fn da,ka,cette

n_a = (fn) -> (da,ta,cette) -> # not array

  [spans,ka] = ta

  if spans[da.arglen] then return UNDEC

  return fn da,ka,cette

arn = {}

arn.a = (da,ta,cette) ->

  [spans,exec] = ta

  if spans[da.arglen] then return UNDEC

  return resolve exec,da.arg,cette

arn.n = (da,ta,cette)  ->

  [num,exec] = ta

  if (da.arglen is num) then return UNDEC

  return resolve exec,da.arg,cette

core.arn = (da,ta,cette) -> arn[ta[0]] da,ta[1],cette

arwhn = {}

arwhn.ob = ob core.whn

arwhn.n = n core.whn

arwhn.a = a core.whn

core.arwhn = (da,ta,cette) -> arwhn[ta[0]] da,ta[1],cette

arnwh = {}

arnwh.n = n_n core.wh

arnwh.a = n_a core.wh

core.arnwh = (da,ta,cette) ->

  arnwh[ta[0]] da,ta[1],cette

arnwhn = {}

arnwhn.n = n_n core.whn

arnwhn.a = n_a core.whn

core.arnwhn = (da,ta,cette) -> arnwhn[ta[0]] da,ta[1],cette

# -----

core.cap = (da,ta,cette) ->

  switch ta.length
  | 3 => core.cap.3 da,ta,cette
  | 2 => core.cap.2 da,ta,cette
  | 1 => resolve ta[0],da.arg,cette

core.cap.2 = (da,ta,cette) ->

  [exec,[vtype,vF]] = ta

  switch vtype

  | \f =>

    ret = vF.apply cette,da.arg

    if ret isnt false

      return unshift_resolve exec,ret,da.arg,cette

  | \v => # .types validator

    vd = vF.auth.apply cette,da.arg

    if vd.continue

      return unshift_resolve exec,vd.value,da.arg,cette

    else

      as_obj = (message:vd.message,path:vd.path)

      narg = [as_obj,...da.arg]

      ret = lastview.apply cette,narg

      if (ret isnt void) then return ret

  | \b =>

    if vF

      return resolve exec,da.arg,cette

  UNDEC

core.cap.3 = (da,ta,cette) ->

  [exec,[vtype,vF],lastview] = ta

  switch vtype
  | \f =>

    ret = vF.apply cette,da.arg

    if isArray ret

      [cont,msg] = ret

      if cont

        return unshift_resolve exec,msg,da.arg,cette

      else

        narg = [msg,...da.arg]

        lvret = lastview.apply cette,narg

    else

      if ret

        return resolve exec,da.arg,cette

      else

        lvret = lastview.apply cette,da.arg

    if (lvret isnt void) then return lvret

  | \v => # .types validator

    vd = vF.auth.apply cette,da.arg

    if vd.continue

      return unshift_resolve exec,vd.value,da.arg,cette

    else

      as_obj = (message:vd.message,path:vd.path)

      narg = [as_obj,...da.arg]

      ret = lastview.apply cette,narg

      if (ret isnt void) then return ret

  | \b =>

    if vF

      return resolve exec,da.arg,cette

    else

      ret = lastview.apply cette,da.arg

      if (ret isnt void) then return ret

  UNDEC


arcap = {}

arcap.ob = ob core.cap

arcap.n = n core.cap

arcap.a = a core.cap

core.arcap = (da,ta,cette) -> arcap[ta[0]] da,ta[1],cette

isArray = Array.isArray

# .arwh  ------------

arwh = {}

arwh.ob = ob core.wh

arwh.n = n core.wh

arwh.a = a core.wh

core.arwh = (da,ta,cette) ->

  arwh[ta[0]] da,ta[1],cette

# .ar  ------------

ar = {}

ar.ob = (da,ta,cette) ->

  pick = ta[da.arglen]

  if not pick then return UNDEC

  resolve pick,da.arg,cette

ar.n = (da,ta,cette) ->

  [num,exec] = ta

  if num is da.arglen

    return resolve exec,da.arg,cette

  return UNDEC

ar.a = (da,ta,cette) ->

  [spans,exec] = ta

  if spans[da.arglen]

    return resolve exec,da.arg,cette

  return UNDEC

core.ar = (da,ta,cette) ->

  ar[ta[0]] da,ta[1],cette


tightloop = (state) -> ->

  if state.unary

    first = arguments[0]

    switch R.type first

    | \Arguments,\Array =>

      arglen    = first.length

    | otherwise =>

      return print.route [\unary_not_array,[(new Error!),state]]

  else

    arglen    = arguments.length

  if (@ is global)

    cette = void

  else

    cette = @

  I         = 0

  fns       = state.fns

  terminate = fns.length

  da = {arglen:arglen,arg:arguments,state:state}

  while I < terminate

    elemento = fns[I]

    devolver = core[elemento[0]] da,elemento[1],cette

    if (devolver != UNDEC) then return devolver

    I += 1

  # --------------------------------------------

  def = state.def

  if def then return resolve def,arguments,cette

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

entry = (data,args,what) ->

  if data is null then return loopError!

  str = data.str

  has = topcache[str]

  if has

    return has[data.key] ...args

  {path,lock,key} = data

  ob = {} # {unary:true},{unary:true,immutable:true}

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
