
pkg = require \./print.common

{com,symbols,print} = pkg

tightloop = require \./tightloop

# ------------------------------------------------------------------

{z,l,R,j,uic,deep_freeze,loopError,tupnest,noop,link} = com

xop = pkg.guard

defset = new Set!

def_or_normal = (F) ->

  switch R.type(F)
  | \Function => return true
  | \Object =>

    if ((F[symbols.htypes]) or (defset.has F)) then return true

    return false

  return false

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

# -------------------------------------------------------

assign_self = -> (self) ->
  @self = self
  @

wrap      = {}
  ..on      = null
  ..functor = null
  ..core    = null

guard     = {}
  ..on      = null
  ..rest    = null

define = {}
  ..and     = null
  ..or      = null
  ..proto   = null
  ..on      = null
  ..basis   = null
  ..block   = null
  ..functor = null
  ..rest    = null

validate   = {}
  ..on     = null
  ..rest   = null

proto       = {}

  ..normal  = assign_self!
  ..functor = assign_self!

  ..core =  assign_self!
  ..try = {}
    ..functor = assign_self!
    ..normal = assign_self!

#---------------------------------------------------------

link.proto do
  proto.core
  proto.try.functor
  proto.try.normal
  proto.normal
  proto.functor

user_wrap = ->

  F = @

  -> (F.auth.apply F,arguments).value

p_core = proto.core.prototype

p_core[symbols.htypes] = true

p_core.auth = tightloop

Object.defineProperty p_core,\wrap,(get:user_wrap,enumerable:true)

# TODO

# for I in [\core,\on,\functor,\misc]

#   wrap[I] = (type) -> ->

wrap.core = (type) -> -> guard.core arguments,@self,type

wrap.functor = (type) -> -> define.functor arguments,@self,type

wrap.misc = (type) -> -> define.rest arguments,@self,type 

main = {}

for val in [\and \tap \or \alt]

  main[val] = wrap.core val

main.on = -> guard.on arguments,@self

for val in [\map \forEach]

  main[val] = wrap.functor val

for val in [\cont \edit \err \jam \fix]

  main[val] = wrap.misc val

create_new_try = (data,type = data.type)->

  switch type
  | \obj,\arr      => new proto.try.functor data
  | otherwise      => new proto.try.normal data

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

  create_new_try data

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

ge = (get:get.end,enumerable:true)

Object.defineProperty proto.try.functor.prototype,\end,ge

Object.defineProperty proto.try.normal.prototype,\end,ge

#---------------------------------------------------------

link_from_main = link.proto_fn main

link_from_main do
  [\and \cont \tap \edit \err \jam \fix]
  proto.core

#---------------------------------------------------------

link_from_main do
  [\or \alt]
  proto.normal
  proto.functor

#---------------------------------------------------------

link_from_main do
  [\map \forEach \on]
  proto.functor

#---------------------------------------------------------

link_from_main do
  [\map \forEach \on]
  proto.try.functor

#---------------------------------------------------------

p_core[uic]                      = print.log \core.normal
proto.try.functor.prototype[uic] = print.log \try.functor
proto.try.normal.prototype[uic]  = print.log \try.normal
proto.normal.prototype[uic]      = print.log \normal
proto.functor.prototype[uic]     = print.log \functor

#---------------------------------------------------------

custom = {}

custom.main = (F) ->

  G = cato F

  data =
     *type    : \custom
      all     : node:G
      index   : 0
      str     : ["{..}"]
      mode    : \normal

  new proto.normal data

custom.err = (type) -> ->

  edata = tupnest do
    [new Error!,\input.fault]
    \custom
    type

  print.route edata

custom.exp = xop

.arn 1,custom.err(\arg_count)

.whn do
  def_or_normal
  custom.err(\not_function)

.def(custom.main)

custom.exp.is_instance = (x) ->

  switch x[symbols.htypes]
  | true => true
  | otherwise => false

#--------------------------------------------------------------------------

define.on = (cat,args,state) ->

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
      *node:[\on,put]
       back:state.all
     index    : state.index + 1
     str      : [\on,state.str]
     mode     : state.mode

  switch data.mode
  | \try =>
    new proto.try.functor data
  | \normal =>
    new proto.functor data

#-----------------------------------------------------------------------

ha =  {}

ha.err = (err_type,args,state)->

  edata = tupnest do
    [new Error!,\input.fault]
    \on
    [err_type]
    [state.str,\on]

  print.route edata

ha.err_static = (type) -> -> ha.err ...[type,...arguments]

ha.validate_obj = (args,state) ->

  [maybe_object] = args

  type = R.type maybe_object

  if (type is \Object)

    for I,val of maybe_object

      if R.type(val) isnt \Function

        return [false,\object]

    return [true,\object]

  else

    return [false,\typeError]

ha.validate_rest = ([first,second],state)->

  type = R.type first

  switch type

  | \Array =>

    for I,index in first

      if not ((R.type I) in [\String,\Number])
        return [false,\array]

    if not def_or_normal(second)

      return [false,\array]

    else

      return [true,\array]

  | \String,\Number =>

    if not def_or_normal(second)

      return [false,\string]

    return [true,\string]

  | otherwise => return [false]

ha[1] =
  *ha.validate_obj
   ha.err
   define.on

ha[2] =
  *ha.validate_rest
   ha.err
   define.on

guard.on = xop.unary

.arn [1,2],ha.err_static \arg_count

.arcap(ha)

.def ha.err_static \typeError

#-----------------------------------------------------------------------

functor = {}

functor.main = (args,state,ftype)->

  if state.type is \arr

    range = args[0]

    mod_range = switch range.length
    | 1 => [range[0],Infinity,1]
    | 2 => [range[0],range[1],1]
    | otherwise => range

    args[0] = mod_range

    args[1] = cato args[1]

  else

    args[0] = cato args[0]

  data =
    *type     : state.type
     all      :
      *node:[ftype,args]
       back:state.all
     index    : state.index + 1
     str      : [ftype,state.str]
     mode     : state.mode

  switch data.mode
  | \try =>
    new proto.try.functor data
  | \normal =>
    new proto.functor data

functor.validate_range = ([range,F],state,type) ->

  if state.type is \obj

    return [false,[\range.obj]]

  if R.type(range) isnt \Array
    return [false,[\range]]

  for item,index in range

    if R.type(item) isnt \Number
      return [false,[\num,index]]

  switch range.length

  | 1,2 => void

  | 3 =>

    step = range[2]

    if step is 0
      return [false,[\inf_step]]

  | otherwise =>

    return [false,[\num_count]]

  if not def_or_normal(F)

    return [false,[\fun,\second]]

  true

functor.validate = ([F],state) ->

  if not def_or_normal(F) then return [false,[\fun,\first]]

  true

functor.err_static = (val) -> ->  functor.err ...[[val],...arguments]

functor.err = (err_type,args,state,type) ->

  edata = tupnest do
    [new Error!,\input.fault]
    type
    [err_type]
    [state.str,type]

  print.route edata

functor[1] =
  *functor.validate
   functor.err
   ([F],state,fname)-> 

    if state.type is \arr
      arg = [[0,Infinity,1],F]
    else
      arg = [F]

    functor.main arg,state,fname

functor[2] =
  *functor.validate_range
   functor.err
   functor.main

functor.def = functor.err_static \undefined_error

define.functor = xop.unary

.arcap(functor)

.arn [1,2],functor.err_static \arg_count

.def(functor.def)

#------------------------------

define.rest = (args,state,type) ->

  #----------------------------------

  fname = type

  switch type

  |\and,\or,\alt =>

    list = [cato I for I in args]

    len = list.length

    if len isnt 1
      fname = type + "." + \multi
      F = list
    else
      F = list[0]

  | \edit =>
    fname = \cont
    fallthrough
  | \err,\fix,\cont,\jam,\edit,\tap =>

    F = args[0]

  switch type
  | \and =>
    node = F
  | \try =>
    node = [fname]
  | otherwise =>
    node = [fname,F]

  data =
    *type:state.type
     all:
       *node:node
        back:state.all
     index:state.index + 1
     mode:state.mode
     str:[type,state.str]

  if (type is \try) or (state.mode is \try)

    create_new_try data

  else

    switch data.type
    | \obj,\arr =>
      new proto.functor data
    | otherwise =>
      new proto.normal data

core = {}

core.err_static = (type) -> -> core.err ...[type,...arguments]

core.err = (err_type,args,state,type) ->

  edata = tupnest do
    [new Error!,\input.fault]
    \rest
    type
    [err_type]
    [state.str,type]

  print.route edata

core.validate = (funs,state,type) ->

  switch type

  | \and,\or,\alt  =>

    if (funs.length is 0)

      return [false,\arg_count]

    for F in funs

      if not def_or_normal(F)

        return [false,\type_error]

    return true

  | \tap =>

    if not (funs.length is 1)

      return [false,\arg_count]

    [F] = funs

    if not def_or_normal(F)

      return [false,\type_error]

    return true

  | otherwise => false

#-----------------------------------------------------------------------

guard.core = xop
.cap do
  core.validate
  core.err
  define.rest
.def core.err_static \undefined_error

#-----------------------------------------------------------------------

define.basis = (name,F,type = name) !->

  data =
    *type     : type
     str      : [name]
     all      : node:[\d,F]
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

#-------------------------------------------------------------------

module.exports =
  *custom        : custom.exp
   define        : define
   defset        : defset
