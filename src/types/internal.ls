{com,print,sig} = require \./print.common

tightloop = require \./tightloop

# ------------------------------------------------------------------

{z,l,R,j,uic,deep_freeze,loopError} = com

xop = require \../guard/main

cache = {}
  ..def = new Set!
  ..ins = new Set!

# ------------------------------------------------------------------

\d # default / base type , arr, obj, ...
\i # instance  
\f # function

assort = (F) ->

  if (cache.def.has F)

    [\d,F]

  else if (cache.ins.has F)

    [\i,F]

  else

    [\f,F]


cato = (arg) ->

  switch R.type arg

  | \Function,\Object => assort arg

  | \Arguments =>

    fun = []

    for I from 0 til arg.length

      F = arg[I]

      block = assort F

      fun.push block

    fun

# -------------------------------------------------------

wrap      = {}
  ..on    = null
  ..rest  = null
  ..try   = null
  ..catch = null

guard     = {}
  ..on    = null
  ..rest  = null
  ..try   = null
  ..catch = null

define = {}
  ..and    = null
  ..or     = null
  ..proto  = null
  ..on     = null
  ..basis  = null

validate   = {}
  ..on     = null
  ..rest   = null

#---------------------------------------------------------

props = [\and \or \alt \cont \tap \edit \err \jam \fix]

init_state =
  all  :[]
  type :null
  str  :[]
  mode : \normal

wrap.rest = (type) -> -> guard.rest arguments,@[sig],type

wrap.on = -> guard.on arguments,@[sig]

proto       = {}
  ..normal  = {}
  ..functor = null

proto.normal.wrap = ->

  F = @

  -> (F.auth.apply F,arguments).value

for val in props

  F = wrap.rest val

  proto.normal[val]  = F

proto.normal.auth      = tightloop

proto.normal[uic]      = print.log

proto.normal.try       = -> _try @[sig]

proto.functor          = {...proto.normal}

proto.functor.map      = wrap.rest \map

proto.functor.forEach  = wrap.rest \forEach

proto.functor.on       = wrap.on

proto.functor[uic]     = print.log

#---------------------------------------------------------

handleError = (info) ->

  print.route info

  loopError!

custom = xop

.arn 1, -> handleError [(new Error!),\input.fault,[\custom [\arg_count]]]

.whn do

  (f) ->

    ((R.type f) is \Function) or (f[sig])

  -> handleError [(new Error!),\input.fault,[\custom [\not_function]]]

.def (F) ->

  G = cato F

  data =
     *type    : \custom
      all     : [[G]]
      str     : ["{..}"]

  define.proto data

custom[uic] = print.inner

#--------------------------------------------------------------------------

define.on = (type,args,state) ->

  switch type[0]
  | \array =>

    [props,F] = args

    put = [\on,[\array,[(R.uniq props),...(cato F)]]]

  | \string =>

    [key,F] = args

    put = [\on,[\string,[key,...(cato F)]]]

    put

  | \object =>

    [ob] = args

    fun   = [[key,...(cato val)] for key,val of ob]

    put = [\on,[\object,fun]]

  | \single_array =>

    array = type[1]

    put = [\on,[\single_array,array]]

  block = define.and state,[put]

  data =
    *type     : state.type
     all      : block
     str      : state.str.concat \on


  define.proto data

#-----------------------------------------------------------------------

guard.on = xop.unary

.arn [1,2],

  (args,state) -> handleError [(new Error!),\input.fault,[\on [\arg_count,[state.str,\on]]]]

.arpar 1,

  (args,state) ->

    [maybe_object] = args

    type = R.type maybe_object

    if (type is \Object)

      for I,val of maybe_object

        if not (((R.type val) is \Function) or (cache.ins.has val))

          return [false,[(new Error!),\input.fault,[\on [\object,[state.str,\on]]]]]

      return [true,[\object]]

    else if (type is \Array)

      ok = true

      clean = []

      error_msg = null

      for each in maybe_object

        if not (each.length is 3)
          ok = false
          error_msg = \length_less_then_3
          break

        [type,fields,F] = each

        field_type = R.type fields

        if type is \and
          if field_type is \String
            field_type = \S
          else if field_type is \Array
            field_type = \A
          else
            error_msg = \alt_wrong_field_type
            ok = false
            break
        else if type is \alt
          if field_type is \Array
            for I in fields
              if not ((R.type I) in [\String,\Number])
                ok = false
                break
            if not ok
              error_msg = \alt_wrong_field_type
              break
            field_type = \A

          else if (field_type is \String)

            field_type = \S

          else
            ok = false
            break
          
        else
          ok = false
          error_msg = \not_and_alt
          break

        wF = assort F

        if wF[0] is \f
          ok = false
          break

        clean.push [type,[field_type,fields],wF[0],wF[1]]

      if ok
        return [true,[\single_array,clean]]
      else

        inner_error = [
          \on
          [\single_array
           [state.str,\on]
           error_msg
          ]

        ]

        return [false,[(new Error!),\input.fault,inner_error]]

    else

      return [false]

  define.on
  (data)->

    if (data[1] is \input.fault) then return handleError data

    null

.arma 2,

  ([first,second],state)->

    switch R.type first

    | \Array =>

      for I in first

        if not ((R.type I) is \String)

          return [(new Error!),\input.fault,[\on [\array,[state.str,\on]]]]

      if not (((R.type second) is \Function) or (cache.ins.has second))

        return [(new Error!),\input.fault,[\on [\array,[state.str,\on]]]]

      return [\array]

    | \String,\Number =>

      if not (((R.type second) is \Function) or (cache.ins.has second))

        return [(new Error!),\input.fault,[\on [\string,[state.str,\on]]]]

      return [\string]

    | otherwise => return false

  define.on

.def (args,state) ->

  handleError [(new Error!),\input.fault,[\on [\typeError,[state.str,\on]]]]

#-----------------------------------------------------------------------

validate.rest = (funs,state,type) ->

  switch type

  | \and,\or,\alt  =>

    if (funs.length is 0)

      print.route [(new Error!),\input.fault,[type,[\arg_count,[state.str,type]]]]

      return false

    for F in funs

      if not (((R.type F) is \Function) or (cache.ins.has F))

        print.route [(new Error!),\input.fault,[type,[\not_function,[state.str,type]]]]

        return false

    return true

  | \map,\tap,\forEach =>

    if not (funs.length is 1)

      print.route [(new Error!),\input.fault,[type,[\arg_count,[state.str,type]]]]

      return false

    return true

    [f] = funs

    if not (((R.type f) is \Function) or (cache.ins.has F))

      print.route [(new Error!),\input.fault,[type,[\not_function,[state.str,type]]]]

      return false

    return true

  | \err,\fix,\cont,\jam,\edit  =>

    return true

  | otherwise => false

_try = (state) ->

  z 'hello world'

  # z.n state.all

#-----------------------------------------------------------------------

guard.rest = xop
.wh do
  validate.rest
  (args,state,type) ->

    #----------------------------------

    funs = cato args

    block = switch type
    | \and                             => define.and state,funs
    | \or                              => define.or state,funs
    | \alt                             => define.or state,[[\alt,funs]]
    | \map,\forEach                    => define.and state,[[type,funs[0]]]
    | \err,\fix,\cont,\jam,\edit,\tap  => define.and state,[[type,args[0]]]

    data =
      *type:state.type
       all:block
       str:state.str.concat type

    define.proto data

.def loopError

#-----------------------------------------------------------------------

define.copy = (F,data,type = data.type) ->

  switch type
  | \obj,\arr,\arg =>

    Object.assign F,proto.functor

  | otherwise =>

    Object.assign F,proto.normal

  F[sig] = data

  cache.ins.add F


define.proto = (data,type = data.type) ->

  switch type
  | \obj,\arr,\arg =>
    put = Object.create proto.functor
  | otherwise =>
    put = Object.create proto.normal

  put[sig] = data

  cache.ins.add put

  put

define.basis = (name,F) ->

  if ((typeof F) is \object)

    inner = []

  else

    inner = [[[\d,F]]]

  cache.def.add F

  data =
    *type     : name
     str      : [name]
     all      : inner
     mode     : \normal

  define.copy F,data

  void

# ------------------------------------------------------------------

define.and = (state,funs) ->

  all = state.all

  mode = state.mode

  switch (all.length%2)
  | 0 =>

    all.concat [funs]

  | 1 =>

    z mode

    # init = R.init all

    # compartment_and = all[all.length - 1]

    # and_init = R.init compartment_and

    # and_last = R.last compartment_and

    # z and_init,and_last

    # and_last.push funs

    # z funs

    # z and_last

    # inner_last = outer_last |> R.last

    # n_inner_last = inner_last.concat funs

    # z funs

    # z all

    # z inner_last

    # z outer_last


    # (R.init outer_last).push n_inner_last

    # nlast = [...last,...funs]

    # block = [...init,nlast]

    # block

    []

define.or = (state,funs) ->

  all = state.all

  switch (all.length%2)
  | 0 =>

    init = R.init all

    last = R.last all

    nlast = [...last,...funs]

    block = [...init,nlast]

    block

  | 1 =>

    all.concat [funs]

#-----------------------------------------------------------------------

module.exports =
  *custom : custom
   define : define
   cache  : cache