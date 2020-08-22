reg = require "./registry"

require "./print" # [...load print.js...]

require "./verify" # [...load print.js...]

{com,already_created,verify,self,print,main} = reg

#---------------------------------------------------

{l,z,R} = com

{util_inspect_custom} = com

#---------------------------------------------------

init =
  str   :[]
  fns   :[]
  def   :null
  ldef  :false
  fault :false

#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------

settle = (F,A) ->

  [ftype,f] = F

  switch ftype
  | \f => f ...A
  | \o => f.pipe ...A
  | \s => f


main.pipe =  !->

  state = @[self]

  if state is undefined
    print.route void,[\state_undefined]
    return null

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


main.wrap = ->

  state = @

  -> main.pipe.apply state,arguments

#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------

looper = (state) ->

  instance = Object.create main

  already_created.add instance

  instance[self] = state

  instance

handle = {}

handle.fault = (state,data,fname) ->

  FT = [\input,fname,data]

  print.route state,FT

  neo = Object.assign {},state,{fault:FT}

  looper neo

handle.ok = (state,data,fname)->

  fns = state.fns.concat {fname:fname,data:data}

  neo = Object.assign {},state,{fns:fns,str:(state.str.concat fname)}


  looper neo

handle.def = {}

handle.def.ok = (state,data)->

  neo = Object.assign do
    {}
    state
    {
      def:data
      str:state.str.concat \def
      ldef:true
    }

  looper neo

handle.def.fault = handle.fault

genfun = (vfun,fname) -> ->

  state = @[self]

  if state.fault then return @

  [zone,data] = vfun arguments

  handle[zone] state,data,fname

#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------

main[util_inspect_custom] = print.log

main.def =  ->

  state = @[self]

  if state.fault then return @

  if state.ldef

    fault-type = [\def_is_defined,\def,'']

    print.route state,fault-type

    neo = Object.assign {},state,{fault:fault-type}

    return looper neo

  [zone,data] = verify.def arguments

  handle.def[zone] state,data,\def

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

reg.hoplon = hoplon


module.exports = hoplon