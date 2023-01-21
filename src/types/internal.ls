{com,print,sig} = require \./print.common

tightloop = require \./tightloop

# ------------------------------------------------------------------

{z,l,R,j,uic,deep_freeze,loopError,tupnest,noop} = com

xop = require \../guard/main

cache_def = new Set!

# ------------------------------------------------------------------

\d # default / base type , arr, obj, ...
\i # instance  
\f # function

def_or_normal = (F) -> (cache_def.has F) or (F instanceof proto.normal)

assort = (F) ->

  if (cache_def.has F)

    [\d,F]

  else if (F instanceof proto.normal)

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

assign_self = -> (self) ->
  @self = self
  @

wrap      = {}
  ..on    = null
  ..rest  = null
  ..catch = null

guard     = {}
  ..on    = null
  ..rest  = null
  ..catch = null

define = {}
  ..and    = null
  ..or     = null
  ..proto  = null
  ..on     = null
  ..basis  = null
  ..block  = null
  ..catch  = null

validate   = {}
  ..on     = null
  ..rest   = null

proto       = {}
  ..normal  = assign_self!
  ..functor = assign_self!
  ..core    = {}
    ..normal = assign_self!
    ..functor = assign_self!

#---------------------------------------------------------

props = [\and \cont \tap \edit \err \jam \fix \try]

proto.core.normal.prototype.wrap = ->

  F = @

  -> (F.auth.apply F,arguments).value

wrap.rest = (type) -> -> guard.rest arguments,@self,type

for val in props

  F = wrap.rest val

  proto.core.normal.prototype[val]  = F

proto.core.normal.prototype.auth   = tightloop

proto.core.normal.prototype[uic]   = print.log \core.normal

proto.core.normal.prototype.catch  = -> guard.catch arguments,@self

proto.core.functor.prototype       = Object.create proto.core.normal.prototype

wrap.on = (type) -> -> guard.on arguments,@self,type

fp                                 = proto.core.functor.prototype

fp.map                             = wrap.rest \map

fp.forEach                         = wrap.rest \forEach

fp.on                              = wrap.on \on

fp.onor                            = wrap.on \onor

fp[uic]                            = print.log \core.functor

#---------------------------------------------------------

proto.normal.prototype = Object.create proto.core.normal.prototype

np = proto.normal.prototype

np.or = wrap.rest \or

np.alt = wrap.rest \alt

np[uic]      = print.log \normal

proto.functor.prototype = Object.create proto.core.functor.prototype

fp = proto.functor.prototype

fp.or = wrap.rest \or

fp.alt = wrap.rest \alt

fp[uic]      = print.log \functor

#---------------------------------------------------------

handleError = (info) ->

  print.route info

  loopError!

custom = xop

.arn 1, -> handleError tupnest (new Error!),\input.fault,\custom,\arg_count

.whn do

  (f) ->

    ((R.type f) is \Function) or def_or_normal f

  -> handleError tupnest (new Error!),\input.fault,\custom,\not_function

.def (F) ->

  G = cato F

  data =
     *type    : \custom
      all     : [\and,G]
      index   : 0
      str     : ["{..}"]

  new proto.normal data

#--------------------------------------------------------------------------

define.on = (cat,args,state,ftype) ->

  put = switch cat
  | \array =>

    [props,F] = args

    [\array,[(R.uniq props),...(cato F)]]

  | \string =>

    [key,F] = args

    [\string,[key,...(cato F)]]

  | \object =>

    [ob] = args

    fun = [[key,...(cato val)] for key,val of ob]

    [\object,fun]

  data =
    *type     : state.type
     all      :
      *node:[ftype,put]
       back:state.all
     index    : state.index + 1
     str      : [ftype,state.str]

  new proto.functor data

#-----------------------------------------------------------------------

guard.on = xop.unary

.arn [1,2],

  (args,state,type) ->

    handleError tupnest do
      *(new Error!),\input.fault
      \on
      \arg_count
      *state.str,type

.arpar 1,

  (args,state,which_on) ->

    [maybe_object] = args

    type = R.type maybe_object

    if (type is \Object)

      for I,val of maybe_object

        if not (((R.type val) is \Function) or (def_or_normal val))

          return tupnest do
            false
            *(new Error!),\input.fault
            \on
            \object
            [state.str,which_on]

      return [true,\object]

    else

      return tupnest do
        false
        [(new Error!),\input.fault]
        \on
        \typeError
        [state.str,which_on]

  (data)->

    if (data[1] is \input.fault) then return handleError data

    loopError!

  define.on

.arpar 2,

  ([first,second],state,type)->

    switch R.type first

    | \Array =>

      for I in first

        if not ((R.type I) in [\String,\Number])

          return tupnest do
            false
            *(new Error!),\input.fault
            \on
            \array
            *state.str,type

      if not (((R.type second) is \Function) or (def_or_normal second))

        return tupnest do
          false
          *(new Error!),\input.fault
          \on
          \array
          *state.str,type

      return [true,\array]

    | \String,\Number =>

      if not (((R.type second) is \Function) or (def_or_normal second))

        return tupnest do
          false
          *(new Error!),\input.fault
          \on
          \string
          *state.str,type

      return [true,\string]

    | otherwise => return false

  (E_info)-> 

    handleError E_info

  define.on

.def (args,state,type) ->

  error_obj = tupnest do
    *(new Error!),\input.fault
    \on
    \typeError
    *state.str,type

  handleError error_obj


#-----------------------------------------------------------------------

validate.rest = (funs,state,type) ->

  switch type

  | \and,\or,\alt  =>

    if (funs.length is 0)

      print.route tupnest [new Error!,\input.fault],type,\arg_count,[state.str,type]

      return false

    for F in funs

      if not (((R.type F) is \Function) or def_or_normal F)

        print.route tupnest [(new Error!),\input.fault],type,\not_function,[state.str,type]

        return false

    return true

  | \map,\tap,\forEach =>

    if not (funs.length is 1)

      print.route tupnest [(new Error!),\input.fault],type,\arg_count,[state.str,type]

      return false

    return true

    [F] = funs

    if not (((R.type f) is \Function) or def_or_normal F)

      print.route tupnest [(new Error!),\input.fault],type,\not_function,[state.str,type]

      return false

    return true

  | \err,\fix,\cont,\jam,\edit,\try  =>

    return true

  | otherwise => false

define.catch = ([F],state) ->

  type = state.type

  data =
    *type:type
     all:
      *node:[\catch,F]
       back:state.all
     index:state.index + 1
     str:[\catch,state.str]

  put = switch type
  | \obj,\arr,\arg => new proto.functor data
  | otherwise      => new proto.normal data

  put

guard.catch = xop.unary

.arpar 1,

  ([F],state) -> ((R.type F) is \Function)

  (...,state)->

    E = tupnest do
      *new Error!,\input.fault
      \catch
      \not_function
      *state.str,\catch

    print.route E

    loopError!

  ([F],skate) -> define.catch [\f,F],state

.ar 0,(...,state) -> define.catch [\empty],state

.arn [1,0],(__,state)->

  handleError tupnest do
    *(new Error!),\input.fault
    \catch
    \arg_count
    *state.str,\catch

.def loopError

#-----------------------------------------------------------------------

guard.rest = xop # [\and \or \alt \cont \tap \edit \err \jam \fix \map]
.wh do
  validate.rest
  (args,state,type) ->

    #----------------------------------

    switch type

    | \and,\map,\alt,\or,\forEach,\onor =>

      F = cato args[0]

    | \err,\fix,\cont,\jam,\edit,\tap =>

      F = args[0]

    | \try =>

      F = void

    data =
      *type:state.type
       all:
        *node:[type,F]
         back:state.all
       index:state.index + 1
       str:[type,state.str]

    switch data.type
    | \obj,\arr,\arg =>

      switch type
      | \try      =>
        new proto.core.functor data
      | otherwise =>
        new proto.functor data

    | otherwise      =>

      switch type
      | \try      =>
        new proto.core.normal data
      | otherwise =>
        new proto.normal data


.def loopError

#-----------------------------------------------------------------------

define.basis = (name,F) !->

  data =
    *type     : name
     str      : [name]
     all      : node:[\and,[\d,F]]
     index    : 0

  F.self = data

  switch name
  | \obj,\arr,\arg =>

    Object.setPrototypeOf F,proto.functor.prototype

  | otherwise =>

    Object.setPrototypeOf F,proto.normal.prototype

  void

define.basis.empty = (name) ->

  data =
    *type     : name
     str      : [name]
     index    : -1

  inherited = switch name

  | \obj,\arr,\arg =>

    new proto.functor data

  | otherwise =>

    new proto.normal data

  inherited

# ------------------------------------------------------------------

#-------------------------------------------------------------------

module.exports =
  *custom    : custom
   define    : define
   cache_def : cache_def