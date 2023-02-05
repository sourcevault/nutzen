{com,symbols,print} = require \./print.common

tightloop = require \./tightloop

# ------------------------------------------------------------------

{z,l,R,j,uic,deep_freeze,loopError,tupnest,noop} = com

xop = require \../guard/main

defset = new Set!

def_or_normal = (F) ->

  if ((F[symbols.htypes]) or (defset.has F)) then return true

  false

# ------------------------------------------------------------------

\d # default / base type , arr, obj, ...
\i # instance  
\f # function

assort = (F) ->

  if F[symbols.htypes]

    [\i,F]

  else if (defset.has F)

    [\d,F]


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

proto_link = (origin,target) !-> target.prototype = Object.create origin.prototype

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
    ..functor = assign_self!
    ..normal = assign_self!

#---------------------------------------------------------

proto_link do
  proto.core.normal
  proto.core.functor

proto_link do
  proto.core.normal
  proto.normal

proto_link do
  proto.core.functor
  proto.functor

user_wrap = ->

  F = @

  -> (F.auth.apply F,arguments).value

p_core = proto.core.normal.prototype

p_core[symbols.htypes] = true

p_core.auth = tightloop

p_core.wrap = user_wrap

wrap.rest = (type) -> -> guard.rest arguments,@self,type

for val in [\and \cont \tap \edit \err \jam \fix]

  F = wrap.rest val

  p_core[val]  = F

create_new_core = (data,type = data.type)->

  switch type
  | \obj,\arr      => new proto.core.functor data
  | otherwise      => new proto.core.normal data

get = {}

get.try = ->

  state = @self

  type = state.type

  data =
    type:type
    all:
      *node:[\try]
       back:state.all
    index:state.index + 1
    mode:\try
    str:[\try,state.str]

  create_new_core data


get.end = ->

  state = @self

  type = state.type

  data =
    type:type
    all:
      *node:[\end]
       back:state.all
    index:state.index + 1
    mode:\normal
    str:[\end,state.str]

  switch data.type
  | \obj,\arr =>
    new proto.functor data
  | otherwise =>
    new proto.normal data

Object.defineProperty p_core,\try,get:get.try

p_core[uic] = print.log \core.normal

Object.defineProperty p_core,\end,get:get.end

wrap.on = (type) -> -> guard.on arguments,@self,type

#---------------------------------------------------------

p = proto.core.functor.prototype

p.map = wrap.rest \map

p.forEach = wrap.rest \forEach

p.on = wrap.on \on

p.onor = wrap.on \onor

p[uic] = print.log \core.functor

#---------------------------------------------------------

pn = proto.normal.prototype

pn.or = wrap.rest \or

pn.alt = wrap.rest \alt

pn[uic] = print.log \normal

#---------------------------------------------------------

p = proto.functor.prototype

p.or = pn.or

p.alt = pn.alt

p[uic] = print.log \functor

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
      mode    : \normal

  new proto.normal data

custom.is_instance = (x) ->
  switch x[symbols.htypes]
  | true => true
  | otherwise => false

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
     mode     : state.mode


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

.arcap 1,

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

.arcap 2,

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

#-----------------------------------------------------------------------

guard.rest = xop # [\and \or \alt \cont \tap \edit \err \jam \fix \map]
.wh do
  validate.rest
  (args,state,type) ->

    #----------------------------------

    switch type
    | \and,\or =>

      list = [cato I for I in args]

      len = list.length

      switch len
      | 1         =>
        type = type
        F = list[0]
      | otherwise =>
        type = type + "." + \multi
        F = list

    | \map,\alt,\forEach,\onor =>

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
       mode:state.mode
       str:[type,state.str]

    if (type is \try) or (state.mode is \try)

      create_new_core data

    else

      switch data.type
      | \obj,\arr =>
        new proto.functor data
      | otherwise =>
        new proto.normal data

.def loopError

#-----------------------------------------------------------------------

define.basis = (name,F,type = name) !->

  data =
    *type     : type
     str      : [name]
     all      : node:[\and,[\d,F]]
     index    : 0
     mode     : \normal

  F.self = data

  switch type
  | \obj,\arr =>

    Object.setPrototypeOf F,proto.functor.prototype

  | otherwise =>

    Object.setPrototypeOf F,proto.normal.prototype

  void

define.basis.empty = (name,type = name) ->

  data =
    *type     : type
     str      : [name]
     index    : -1
     mode     : \normal

  inherited = switch type

  | \obj,\arr =>

    new proto.functor data

  | otherwise =>

    new proto.normal data

  inherited

# ------------------------------------------------------------------

#-------------------------------------------------------------------

module.exports =
  *custom        : custom
   define        : define
   defset        : defset
