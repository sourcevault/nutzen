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

    | \ma =>

      switch data.length

      | 1 =>

        ret = data[0] ...arguments

        if ret
          return ret


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

    | \whn =>

      [validator,fin] = data

      if not (validator ...arguments)

        return settle fin,arguments

    # --------------------------------------------

    | \ar =>

      [spans,F] = data

      [ltype,lens] = spans

      switch ltype

      | \n =>

        if (lens is arglen)

          return settle F,arguments

      | \a =>

        Jn = lens.length

        J = 0

        do
          if (lens[J] is arglen)

            return settle F,arguments

          J += 1

        while J < Jn

    # --------------------------------------------

    | \arn =>

      [spans,fin] = data

      [ltype,lens] = spans

      switch ltype

      | \n =>

        if not (lens is arglen)

          return settle fin,arguments

      | \a =>

        Jn = lens.length

        J = 0

        has = false

        do

          if (lens[J] is arglen)

            has = true

          if not has

            return settle fin,arguments

          J += 1

        while J < Jn



    # --------------------------------------------

    | \arwh     =>

      [spans,validator,fin] = data

      [ltype,lens] = spans

      switch ltype

      | \n =>

        if (lens is arglen)
          if validator ...arguments
            return settle fin,arguments

      | \a =>

        Jn = lens.length

        J = 0

        do

          if (lens[J] is arglen)
            if validator ...arguments
              return settle fin,arguments

            J += 1
        while J < Jn

    # --------------------------------------------

    | \arma     =>

      [spans,funs] = data

      [ltype,lens] = spans

      switch ltype

      | \n =>

        if (lens is arglen)

          if (funs.length is 1)

            ret = funs[0] ...arguments

            if ret

              return ret

          else

            Jn = funs.length

            J = 0

            do

              ret = funs[J] ...arguments

              if ret

                return ret

                J += 1

            while J < Jn

      | \a =>


        [spans,funs] = data

        [ltype,lens] = spans

        Jn = lens.length

        J = 0

        do

          if (lens[J] is arglen)

            if (funs.length is 1)

              ret = funs[0] ...arguments

              if ret
                return ret

            else

              Kn = funs.length

              K = 0

              do

                ret = funs[K] ...arguments

                if ret
                  return ret

                K += 1
              while K < Kn

          J += 1
        while J < Jn

    # --------------------------------------------

    | \arwhn    =>

      [spans,validator,fin] = data

      [ltype,lens] = spans

      switch ltype

      | \n =>

        if (lens is arglen)

          if not (validator ...arguments)
            return settle fin,arguments

      | \a =>

        Jn = lens.length

        J = 0

        do

          if (lens[J] is arglen)

            if not (validator ...arguments)
              return settle fin,arguments

          J += 1
        while J < Jn

    # --------------------------------------------

    | \arnwh    =>

      [spans,validator,fin] = data

      [ltype,lens] = spans

      switch ltype

      | \n =>

        if not (lens is arglen)
          if (settle validator,arguments)
            return settle fin,arguments

      | \a =>

        Jn = lens.length

        J = 0

        has = false

        do

          if (lens[J] is arglen)

            has = true

          J += 1

        while J < Jn

        if not has
          if (settle validator,arguments)
            return settle fin,arguments



    # --------------------------------------------

    | \arnwhn    =>

      [spans,validator,fin] = data

      [ltype,lens] = spans

      switch ltype

      | \n =>

        if not (lens is arglen)
          if not (validator ...arguments)
            return settle fin,arguments

      | \a =>

        Jn = lens.length

        J = 0

        has = false

        do

          if (lens[J] is arglen)

            has = true

          J += 1
        while J < Jn

        if not has
          if not (validator ...arguments)
            return settle fin,arguments


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




