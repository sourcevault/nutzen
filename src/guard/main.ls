ext = require "./verify.print.common"

{com,verify,modflag,print} = ext

{l,z,R,uic,binapi} = com

#---------------------------------------------------

init =
  str      :[]
  fns      :[]
  def      :null
  fault    :false
  unary    :false
  immutable:false

#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------

settle = (F,A) ->

  [ftype,f] = F

  switch ftype
  | \f => f ...A
  | \v => f.auth ...A
  | \s => f

mod-settle = (F,init,A) ->

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

  while I < terminate

    {fname,data} = fns[I]

    switch fname

    # --------------------------------------------

    | \wh =>

      [[vtype,validatorF],exec] = data

      switch vtype

      | \f =>

        cont = validatorF ...arguments

        if cont

          return settle exec,arguments

      | \v =>

        vd = validatorF.auth arguments

        if vd.continue

          return (settle exec,vd.value)

    # --------------------------------------------

    | \whn =>

      [[vtype,validatorF],exec] = data

      switch vtype

      | \f =>

        cont = validatorF ...arguments

        if not cont

          return settle exec,arguments

      | \v =>

        vd = validatorF.auth arguments

        if vd.error

          return (settle exec,vd.value)

    # --------------------------------------------

    | \ar =>

      [spans,exec] = data

      if spans[arglen]

        return settle exec,arguments

    # --------------------------------------------

    | \arn =>

      [spans,exec] = data

      if not spans[arglen]

        return settle exec,arguments

    # --------------------------------------------

    | \arwh     =>

      [spans,[vtype,validatorF],exec] = data

      if spans[arglen]

        switch vtype

        | \f =>

          cont = validatorF ...arguments

          if cont

            return settle exec,arguments

        | \v =>

          vd = validatorF.auth arguments

          if vd.continue

            return (settle exec,vd.value)

    # --------------------------------------------

    | \ma =>

      [[vtype,validatorF],exec] = data

      switch vtype

      | \f =>

        msg = validatorF ...arguments

        if msg

          return mod-settle exec,msg,arguments

      | \v =>

        vd = validatorF.auth arguments

        if vd.continue

          return mod-settle exec,vd.value,arguments

    | \arma     =>

      [spans,[vtype,validatorF],exec] = data

      if spans[arglen]

        switch vtype

        | \f =>

          msg = validatorF ...arguments

          if msg

            return mod-settle exec,msg,arguments

        | \v =>

          vd = validatorF.auth arguments

          if vd.continue

            return mod-settle exec,vd.value,arguments

    # --------------------------------------------

    | \arpar    =>

      [spans,[vtype,validatorF],exec,lastview] = data

      switch vtype

      | \f =>

        ret = validatorF ...arguments

        if not (Array.isArray ret)

          print.route [\arpar_not_array,[(new Error!),state]]

          return void

        [cont,msg] = ret

        if cont

          return mod-settle exec,msg,arguments

        else

          msg = switch R.type msg
          | \Array    => msg
          | \Undefined,\Null => []
          | otherwise => msg

          ret = lastview msg

          if not (ret in [void,false,null]) then return ret

      | \v =>

        vd = validatorF.auth arguments

        if vd.continue

          return mod-settle exec,vd.value,arguments

        else

          ret = lastview vd.message,vd.path

          if not (ret in [void,false,null]) then return ret


    # --------------------------------------------

    | \arwhn    =>

      [spans,[vtype,validatorF],exec] = data

      if spans[arglen]

        switch vtype

        | \f =>

          cont = validatorF ...arguments

          if not cont

            return settle exec,arguments

        | \v =>

          vd = validatorF.auth arguments

          if vd.error

            return (settle exec,vd.value)

    # --------------------------------------------

    | \arnwh    =>

      [spans,[vtype,validatorF],exec] = data

      if not spans[arglen]

        switch vtype

        | \f =>

          cont = validatorF ...arguments

          if cont

            return settle exec,arguments

        | \v =>

          vd = validatorF.auth arguments

          if vd.continue

            return (settle exec,vd.value)

    # --------------------------------------------

    | \arnwhn    =>

      [spans,[vtype,validatorF],exec] = data

      if not spans[arglen]

        switch vtype

        | \f =>

          cont = validatorF ...arguments

          if not cont

            return settle exec,arguments

        | \v =>

          vd = validatorF.auth arguments

          if vd.error

            return (settle exec,vd.value)

    I += 1

  # --------------------------------------------

  def = state.def

  if def then return settle def,arguments


#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------
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


handle.ok = (self,data,fname)->

  state = self[modflag]

  if (state.immutable) or (state.str.length is 0)

    fns = state.fns.concat {fname:fname,data:data}

    neo = Object.assign {},state,{fns:fns,str:(state.str.concat fname)}

    looper neo

  else

    state.fns.push {fname:fname,data:data}

    state.str.push fname

    neo = state

    self

handle.def = {}

handle.def.fault = -> null

handle.def.fault[uic] = print.log.def_fault

handle.def.ok = (self,data) ->

  state = self[modflag]

  neo = Object.assign do
    {}
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

  if state is undefined

    print.route [\state_undef,[(new Error!),fname]]

    return undefined

  if state.fault then return @

  [zone,data] = vfun arguments


  handle[zone] @,data,fname

#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------

main[uic] = print.log.proto

main.def =  ->

  state = @[modflag]

  if state is undefined

    print.route [\state_undef,[(new Error!),\def]]

    return undefined

  if state.fault then return handle.def.fault

  [zone,data] = verify.def arguments

  handle.def.ok @,data

props = [\ma \arma \wh \ar \whn \arn \arwh \arnwh \arwhn \arnwhn \arpar]

#---------------------------------------------------

R.reduce do

  (ob,prop) ->

    ob[prop] = genfun (verify.getvfun prop),prop

    ob

  main
  props

#---------------------------------------------------

cat = {}

cat.opt = new Set [\unary,\immutable,\debug]

cat.methods = new Set (props.concat ["def"])

getter = ({path,lock,str,vr},key) ->

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

      {path:sorted,lock:false,str:(sorted.join "."),vr:npath}

  else if cat.methods.has key

    {path:path,lock:true,str:str,vr:vr,key:key}

  else

    print.route [\setting,[(new Error!),\not_in_opts,vr,key]]

    null

topcache = {}

entry = (data,args) ->

  str = data.str

  has = topcache[str]

  if has
    return has[data.key] ...args

  {path,lock,vr,key} = data

  ob = {}

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
