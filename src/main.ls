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
  immutable:false
  mutelog  :false

#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------

settle = (F,A) ->

  [ftype,f] = F

  switch ftype
  | \f => f ...A
  | \s => f

tightloop =  (state) -> ->

  arglen = arguments.length

  for {fname,data} in state.fns

    switch fname

    # --------------------------------------------

    | \ma =>

      J = data.length

      I = 0

      switch data.length
      | 1 =>

        ret = settle data[0],arguments

        if ret
          return ret


      | otherwise =>

        while (I < J)

          ret = settle data[I],arguments

          if ret
            return ret

          I += 1

    # --------------------------------------------

    | \wh =>

      [validator,fin] = data

      if (settle validator,arguments)
        return settle fin,arguments

    # --------------------------------------------

    | \whn =>

      [validator,fin] = data

      if not (settle validator,arguments)
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

        J = data.length

        I = 0

        while (I < J)

          if (I is arglen)
            return settle F,arguments

          I += 1

    # --------------------------------------------

    | \arn =>

      [spans,fin] = data

      [ltype,lens] = spans

      switch ltype

      | \n =>

        if not (lens is arglen)

          return settle fin,arguments

      | \a =>

        J = lens.length

        I = 0

        while (I < J)
          if not (lens[I] is arglen)
            return settle fin,arguments

          I += 1

    # --------------------------------------------

    | \arwh     =>

      [spans,validator,fin] = data

      [ltype,lens] = spans


      switch ltype

      | \n =>

        if (lens is arglen)
          if settle validator,arguments
            return settle fin,arguments

      | \a =>

        J = lens.length

        I = 0

        while (I < J)

          if (lens[I] is arglen)

            if settle validator,arguments
              return settle fin,arguments

          I += 1

    # --------------------------------------------

    | \arwhn    =>

      [spans,validator,fin] = data

      [ltype,lens] = spans

      switch ltype

      | \n =>

        if (lens is arglen)

          if not (settle validator,arguments)
            return settle fin,arguments

      | \a =>

        J = lens.length

        I = 0

        while (I < J)

          if (lens[I] is arglen)

            if not (settle validator,arguments)
              return settle fin,arguments

          I += 1

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

        J = lens.length

        I = 0

        while (I < J)

          if not (lens[I] is arglen)

            if (settle validator,arguments)
              return settle fin,arguments

          I += 1

    # --------------------------------------------

    | \arnwhn    =>

      [spans,validator,fin] = data

      [ltype,lens] = spans

      switch ltype

      | \n =>

        if not (lens is arglen)
          if not (settle validator,arguments)
            return settle fin,arguments

      | \a =>

        J = lens.length

        I = 0

        while (I < J)

          if not (lens[I] is arglen)

            if not (settle validator,arguments)
              return settle fin,arguments

          I += 1

    # --------------------------------------------

  def = state.def

  if def

    return settle def,arguments

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

handle.def.ok = (self,data) ->

  state = self[modflag]

  neo = Object.assign do
    {}
    state
    {
      def:data
      str:state.str.concat \def
    }

  F  = tightloop neo

  F[uic] = print.log.wrap neo

  F

handle.def.fault = handle.fault

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

  if state.fault then return @

  [zone,data] = verify.def arguments

  handle.def[zone] @,data,\def

props = [\ma \wh \ar \whn \arn \arwh \arnwh \arwhn \arnwhn]

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

hoplon.mutelog = looper Object.assign do
  {}
  init
  {mutelog:true}

hoplon.immutable.mutelog = looper Object.assign do
  {}
  init
  {immutable:true,mutelog:true}

hoplon.mutelog.immutable = looper Object.assign do
  {}
  init
  {immutable:true,mutelog:true}

# ------------------------------------------------

Object.freeze hoplon

reg.hoplon = hoplon

module.exports = hoplon




