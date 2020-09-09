reg = require "./registry"

require "./print" # [...load print.js...]

require "./verify" # [...load print.js...]

{com,already_created,verify,modflag,print,main} = reg

#---------------------------------------------------

{l,z,R,uic} = com

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

  do

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

        do

          ret = data[J] ...arguments

          if ret
            return ret

          J += 1
        while J < Jn

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

          do

            ret = funs[J] ...arguments

            if ret
              return ret

            J += 1
          while J < Jn


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
  while I < terminate

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

  instance

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

hoplon = looper init

hoplon.immutable = looper Object.assign do
  {}
  init
  {immutable:true}

hoplon.unary = looper Object.assign do
  {}
  init
  {unary:true}

hoplon.immutable.unary = looper Object.assign do
  {}
  init
  {immutable:true,unary:true}

hoplon.unary.immutable = looper Object.assign do
  {}
  init
  {immutable:true,unary:true}

# ------------------------------------------------

Object.freeze hoplon

reg.hoplon = hoplon

module.exports = hoplon




