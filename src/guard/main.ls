ext = require "./verify.print.common"

{com,verify,modflag,print} = ext

{l,z,R,uic,binapi} = com

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
    | 0 => f init
    | 3 => f init,A[0],A[1],A[2]
    | 4 => f init,A[0],A[1],A[2],A[3]
    | 5 => f init,A[0],A[1],A[2],A[3],A[4]
    | otherwise =>

      mod-arg = [init,...A]

      f ...mod-arg

  | \v =>

    switch A.length
    | 1 => f.auth init,A[0]
    | 2 => f.auth init,A[0],A[1]
    | 0 => f.auth init
    | 3 => f.auth init,A[0],A[1],A[2]
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

  [[vtype,vF],exec] = ta

  switch vtype

  | \f =>

    cont = vF ...da.arg

    if cont

      return resolve exec,da.arg

  | \v =>

    vd = vF.auth da.arg

    if vd.continue

      return resolve exec,vd.value

  | \b =>

    if vF

      return resolve exec,da.arg

  UNDEC

core.whn = (da,ta) ->

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

core.arnwh = (da,ta) -> arnwh[ta[0]] da,ta[1]

arnwhn = {}

arnwhn.n = n_n core.whn

arnwhn.a = n_a core.whn

core.arnwhn = (da,ta) -> arnwhn[ta[0]] da,ta[1]

# -----

core.ma = (da,ta) ->

  [[vtype,vF],exec] = ta

  switch vtype

  | \f =>

    msg = vF.apply void,da.arg

    switch msg
    | false     => void
    | void      => return void
    | otherwise =>
      return unshift_resolve exec,msg,da.arg

  | \v =>

    vd = vF.auth da.arg

    if vd.continue

      return unshift_resolve exec,vd.value,da.arg

  | \b =>

    if vF isnt false

      return unshift_resolve exec,vF,da.arg

  UNDEC

arma = {}

arma.ob = ob core.ma

arma.n = n core.ma

arma.a = a core.ma

core.arma = (da,ta) -> arma[ta[0]] da,ta[1]

isArray = Array.isArray

common_par = (fname)-> (da,ta) ->

  [[vtype,vF],lastview,exec] = ta

  switch vtype
  | \f =>

    ret = vF.apply void,da.arg

    if isArray ret

      [cont,msg] = ret

      if cont

        return unshift_resolve exec,msg,da.arg

      else

        lvret = lastview msg,...da.arg

    else

      if ret

        return resolve exec,da.arg

      else

        lvret = lastview.apply void,da.arg

    if (lvret isnt void) then return ret

  | \v => # hoplon validator

    vd = vF.auth da.arg

    if vd.continue

      return unshift_resolve exec,vd.value,da.arg

    else

      ret = lastview vd.message,vd.path,...da.arg

      if (ret isnt void) then return ret

  | \b =>

    if vF

      return resolve exec,da.arg

    else

      ret = lastview.apply void,da.arg

      if (ret isnt void) then return ret

  UNDEC

core.par = common_par \par

arpar = {}

f_arpar = common_par \arpar

arpar.ob = ob f_arpar

arpar.n = n f_arpar

arpar.a = a f_arpar

core.arpar = (da,ta) ->

  arpar[ta[0]] da,ta[1]

# .arwh  ------------

arwh = {}

arwh.ob = ob core.wh

arwh.n = n core.wh

arwh.a = a core.wh

core.arwh = (da,ta) -> arwh[ta[0]] da,ta[1]

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

main = {}

looper = (state) ->

  instance = Object.create main

  instance[modflag] = state

  frozen = Object.freeze instance

  frozen

handle = {}

handle.fault = (self,data,fname) ->

  state = self[modflag]

  print.route [\input,[(new Error!),fname,data,state]]

  neo = Object.assign {},state,{fault:[\input,fname,data]}

  looper neo

main.clone = ->

  state = @[modflag]

  neo = R.mergeRight state,{fns:[...state.fns],str:[...state.str]}

  looper neo

handle.ok = (self,data,fname)->

  state = self[modflag]

  neo_data = [fname,data]

  if (state.immutable) or (state.str.length is 0)

    fns = state.fns.concat [neo_data]

    neo = R.mergeRight state,{fns:fns,str:(state.str.concat fname)}

    looper neo

  else

    state.fns.push neo_data

    state.str.push fname

    self

handle.def = {}

handle.def.fault = -> null

handle.def.fault[uic] = print.log.def_fault

handle.def.ok = (self,data) ->

  state = self[modflag]

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

genfun = (vfun,fname) -> ->

  state = @[modflag]

  if state is void

    print.route [\state_undef,[(new Error!),fname]]

    return void

  if state.fault then return @

  out = vfun fname,arguments

  [zone,data] = out

  handle[zone] @,data,fname

#---------------------------------------------------

main[uic] = print.log.proto

main.def =  ->

  state = @[modflag]

  if state is undefined

    print.route [\state_undef,[(new Error!),\def]]

    return undefined

  if state.fault then return handle.def.fault

  [___,data] = verify.def arguments

  handle.def.ok @,data

props =
  *\ar
   \wh
   \ma
   \arma
   \par
   \arpar
   \whn
   \arn
   \arwh
   \arwhn
   \arnwh
   \arnwhn

#---------------------------------------------------

R.reduce do

  (ob,prop) ->

    F = verify.getvfun prop

    ob[prop] = genfun F,prop

    ob

  main
  props

#---------------------------------------------------

cat = {}

cat.opt = new Set [\unary,\immutable,\debug]

cat.methods = new Set props.concat [\def]

# Set(12) {'ma', 'arma', 'wh', 'ar', 'whn', 'arn', 'arwh', 'arnwh', 'arwhn', 'arnwhn', 'arpar', 'def'}

getter = (data,key) ->

  {path,lock,str,vr} = data

  if lock

    print.route [\setting,[(new Error!),\path_locked,vr,key]]

    return null

  if cat.opt.has key

    if (R.includes key,path)

      print.route [\setting,[(new Error!),\already_in_path,vr,key]]

      null

    else

      npath = path.concat key

      sorted = (R.clone npath).sort!

      [true,{path:sorted,lock:false,str:(sorted.join "."),vr:npath}]

  else if cat.methods.has key

    [true,{path:path,lock:true,str:str,vr:vr,key:key}]

  else

    print.route [\setting,[(new Error!),\not_in_opts,vr,key]]

    null

topcache = {}

init =
  str      :[]
  fns      :[]
  def      :null
  fault    :false
  unary    :false
  immutable:false

entry = (data,args) ->

  str = data.str

  has = topcache[str]

  if has
    return has[data.key] ...args

  {path,lock,vr,key} = data

  ob = {} # { debug: true },{debug: true, immutable:true}

  for ke in path
    ob[ke] = true

  put = looper Object.assign do
    {}
    init
    ob

  topcache[str] = put

  put[key] ...args

pkg = binapi do
  entry,getter,{path:[],lock:false,vr:[],str:[],key:null}
  print.log.prox


module.exports = pkg