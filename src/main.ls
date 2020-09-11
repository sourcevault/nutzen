reg = require "./registry"

require "./print" # [...load print.js...]

require "./verify" # [...load print.js...]

{com,already_created,verify,modflag,print,main} = reg

#---------------------------------------------------

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
  | \s => f

tightloop = (state) -> ->

  if state.unary

    first = arguments[0]

    switch R.type first

    | \Arguments,\Array =>

      arglen    = first.length

    | otherwise =>

      print.route [[\not_array],state]

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

      [validator,fin] = data

      if (validator ...arguments)

        return (settle fin,arguments)

    # --------------------------------------------

    | \whn =>

      [validator,F] = data

      if not (validator ...arguments)

        return settle F,arguments

    # --------------------------------------------

    | \ar =>

      [spans,F] = data

      if spans[arglen]

        return settle F,arguments

    # --------------------------------------------

    | \arn =>

      [spans,F] = data

      if not spans[arglen]

        return settle F,arguments

    # --------------------------------------------

    | \arwh     =>

      [spans,validator,F] = data

      if spans[arglen] and (validator ...arguments)

        return settle fin,arguments


    # --------------------------------------------

    | \ma =>

      switch data.length

      | 1 =>

        ret0 = data[0] ...arguments

        if ret0
          return ret0

      | 2 =>

        ret0 = data[0] ...arguments

        if ret0
          return ret0

        ret1 = data[1] ...arguments

        if ret1
          return ret1

      | 3 =>

        ret0 = data[0] ...arguments

        if ret0
          return ret0

        ret1 = data[1] ...arguments

        if ret1
          return ret1

        ret2 = data[2] ...arguments

        if re2
          return ret2

      | 4 =>

        ret0 = data[0] ...arguments

        if ret0
          return ret0

        ret1 = data[1] ...arguments

        if ret1
          return ret1

        ret2 = data[2] ...arguments

        if re2
          return ret2

        ret3 = data[3] ...arguments

        if re3
          return ret3

      | otherwise =>

        Jn = data.length

        J = 0

        while J < Jn

          ret = data[J] ...arguments

          if ret
            return ret

          J += 1

    # --------------------------------------------

    | \arma     =>

      if data[0][arglen]

        funs = data[1]

        switch funs.length
        | 1 =>

          ret0 = funs[0] ...arguments

          if ret0
            return ret0

        | 2 =>

          ret0 = funs[0] ...arguments

          if ret0
            return ret0

          ret1 = funs[1] ...arguments

          if ret1
            return ret1

        | 3 =>

          ret0 = funs[0] ...arguments

          if ret0
            return ret0

          ret1 = funs[1] ...arguments

          if ret1
            return ret1

          ret2 = funs[2] ...arguments

          if re2
            return ret2

        | 4 =>

          ret0 = funs[0] ...arguments

          if ret0
            return ret0

          ret1 = funs[1] ...arguments

          if ret1
            return ret1

          ret2 = funs[2] ...arguments

          if re2
            return ret2

          ret3 = funs[3] ...arguments

          if re3
            return ret3

        | otherwise =>

          Jn = data.length

          J = 0

          while J < Jn

            ret = funs[J] ...arguments

            if ret
              return ret

            J += 1


    # --------------------------------------------

    | \arwhn    =>

      [spans,validator,F] = data

      if spans[arglen] and not (validator ...arguments)

        return settle F,arguments

    # --------------------------------------------

    | \arnwh    =>

      [spans,validator,F] = data

      if (not spans[arglen]) and (validator ...arguments)

        return settle F,arguments

  #   # --------------------------------------------

    | \arnwhn    =>

      [spans,validator,F] = data

      if not ((spans[arglen]) and (validator ...arguments))

        return settle F,arguments

    I += 1

  # --------------------------------------------

  def = state.def

  if def
    switch def[0]
    | \f => return def[1] ...arguments
    | \s => return def[1]


#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------

looper = (state) ->

  instance = Object.create main

  instance[modflag] = state

  frozen = Object.freeze instance

  frozen

handle = {}

handle.fault = (self,data,fname) ->

  state = self[modflag]

  FT = [\input,fname,data]

  print.route [FT,state]

  neo = Object.assign {},state,{fault:FT}

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

  if state.fault then return handle.def.fault

  [zone,data] = verify.def arguments

  handle.def.ok @,data

props = [\ma \arma \wh \ar \whn \arn \arwh \arnwh \arwhn \arnwhn]

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

cat.methods = new Set props

getter = ({path,lock,str,vr},key) ->

  if lock

    print.route [[\setting,\path_locked],[vr,key]]

    return null

  if cat.opt.has key

    if (R.includes key,path)

      print.route [[\setting,\already_in_path],[vr,key]]

      null

    else

      npath = path.concat key

      sorted = (R.clone npath).sort!

      {path:sorted,lock:false,str:(sorted.join "."),vr:npath}

  else if cat.methods.has key

    {path:path,lock:true,str:str,vr:vr,key:key}

  else

    print.route [[\setting,\not_in_opts],[vr,key]]

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

reg.hoplon = pkg

module.exports = pkg
