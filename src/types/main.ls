pkg = require \./print.common

internal = require \./internal

{com,print} = pkg

# --------------------------

{z,l,R,j,deep_freeze,uic,loopError,noop} = com

xop = pkg.guard

{custom,define,defset} = internal

be = custom

#---------------------------

# first column is the function name, second column is error message.

non_map_props =
  [\undef \Undefined]
  [\null \Null]
  [\num \Number]
  [\str \String]
  [\fun \Function]
  [\bool \Boolean]
  [\objerr \Error]

props =
  [\obj \Object]
  [\arr \Array]
  ...non_map_props


base = (type) -> (UFO) ->

  if ((R.type UFO) is type)

    {continue:true,error:false,value:UFO}

  else

    str = R.toLower "not #{type}"

    {error:true,continue:false,message:str,value:UFO}

not_base = (type) -> (UFO) ->

  if ((R.type UFO) is type)

    str = R.toLower "is #{type}"

    {error:true,continue:false,message:str,value:UFO}

  else

    {continue:true,error:false,value:UFO}

# ---------------------------

undefnull = (UFO) ->

  if ((R.type UFO) in [\Undefined \Null])

    return {continue:true,error:false,value:UFO}

  else

    return {continue:false,error:true,message:"not undefined or null",value:UFO}

defset.add undefnull

# ----------------------------

F = base \Arguments

define.basis \arg,F,\arr

define.basis.empty \arg,\arr

be.arg = F

# -----------------------------

be.not = (F,msg = void) ->

  V = be(F)

  be (x) ->

    von = V.auth x

    if von.continue

      *continue:false
       error:true
       message:msg

    else

      *continue:true
       error:false
       value:von.value

# ----------------------------

be.undefnull = be undefnull

be.not.undefnull = be.not do
  undefnull
  "is undefined or null"

# ----------------------------

be.maybe = (F) ->

  be(F).or(be.undef)
  .err (msg) -> msg.pop! ; msg

# -----------------------------

be.list  = (F) -> be.arr.map F

# -----------------------------

for [name,type] in props

  A = base type

  base name,A

  define.basis name,A

  be[name] = A

  #----------------------------

  B = not_base type

  define.basis name,B

  be.not[name] = B

  #----------------------------

#------------------------------

for [name] in non_map_props

  be.maybe[name] = be.maybe be[name]

be.maybe.obj = be.obj.or be.undef

be.maybe.arr = be.arr.or be.undef

# ------------------------------

resreq = {}

resreq.gen_error = (data) ->

  print.route [(new Error!),\resreq,data]

resreq.not_array_of_str_or_num = (type) -> ->

  args = R.flatten [...arguments]

  for key in args

    if not ((R.type key) in [\String \Number])

      return [type]

  return false

resreq.both = (req,res) ->

    if not (((R.type req) is \Array) and (((R.type res) is \Array)))

      return [\resreq,\prime]

    for I in req

      if not ((R.type I) in [\String \Number])

        return [\resreq,\res]

    for I in res

      if not ((R.type I) in [\String \Number])

        return [\resreq,\req]

    false

objarr = (be.obj.alt be.arr).err "not object or array"

resreq.req = ->

  props = R.flatten [...arguments]

  F = be.not.undef.err [\:req,props]

  von = objarr.on props,F

  von

reqError = xop.wh do
  resreq.not_array_of_str_or_num \req
  resreq.gen_error

resError = xop.wh do
  resreq.not_array_of_str_or_num \res
  resreq.gen_error


resreqError = xop.cap do
  resreq.both
  resreq.gen_error

# #------------------------------------------------------

be.required = reqError.def resreq.req

# #------------------------------------------------------

restricted = (props,po) -> (obj) ->

  keys = Object.keys obj

  for I in keys

    if not po[I]

      return [false,[\:res,props],I]

  true

be.restricted = resError.def ->

  props = R.flatten [...arguments]

  po = {}

  for I in props

    po[I] = true

  objarr.and restricted props,po

be.resreq = resreqError.def (req,res) ->

  po = {}

  for I in res

    po[I] = true

  objarr.on req, be.not.undef.err [\:req,req]
  .and restricted res,po

# #-----------------------------------------------

integer = (UFO) ->

  if not ((R.type UFO) is \Number)

    return {continue:false,error:true,message:"not an integer ( or number )",value:UFO}

  residue = Math.abs (UFO - Math.round(UFO))

  if (residue > 0)

    return {continue:false,error:true,message:"not an integer",value:UFO}

  else

    return {continue:true,error:false,value:UFO}


defset.add integer

# # -----------------------------------------------

boolnum = (UFO) ->

  if ((R.type UFO) in [\Boolean \Number])

    return {continue:true,error:false,value:UFO}

  else

    return {continue:false,error:true,message:"not a number or boolean",value:UFO}

defset.add boolnum

# #------------------------------------------------

maybe_boolnum = (UFO) ->

  if ((R.type UFO) in [\Undefined \Boolean \Number])

    return {continue:true,error:false,value:UFO}

  else

    return {continue:false,error:true,message:"not a number or boolean",value:UFO}


defset.add maybe_boolnum

# #------------------------------------------------

be.int     = be integer

be.boolnum = be boolnum

# #-------------------------------------------------

be.int.neg  = be.int.and do
  (x) ->
    if (x <= 0)
      return true
    else
      return [false,"not a negative integer"]

be.int.pos  = be.int.and do
  (x) ->
    if (x >= 0)
      return true
    else
      return [false,"not a positive integer"]

# #-------------------------------------------------

maybe          = be.maybe

maybe.int      = be.int.or be.undef

maybe.int.pos  = maybe be.int.pos

maybe.int.neg  = maybe be.int.neg

maybe.boolnum  = be maybe_boolnum

# # -------------------------------------------------

list = be.list

list.ofstr = list be.str
.err (msg,key)->

  switch R.type key
  | \Undefined => "not a list of string."
  | otherwise  => [\:list ,[key[0],"not string type"]]

list.ofnum = list be.num
.err (msg,key) ->

  switch R.type key
  | \Undefined =>  "not a list of number."
  | otherwise  => [\:list,[key[0],"not number type"]]

list.ofint = list be.int
.err (msg,key) ->

  switch R.type key
  | \Undefined => "not a list of integer."
  | otherwise  => [\:list,[key[0],"not integer type"]]

maybe.list = {}

maybe.list.ofstr = maybe list.ofstr

maybe.list.ofnum = maybe list.ofnum

maybe.list.ofint = maybe list.ofint

# # -----------------------------------

flatro = {}

flatro.sort = ([txt1],[txt2]) ->

  [__,name1,number1] = txt1.split ":"

  if (number1 is void)

    number1 = 0

  else

    number1 = parseInt number1

  [__,name2,number2] = txt2.split ":"

  if (number2 is void)

    number2 = 0

  else

    number2 = parseInt number2

  if number1 > number2 then return -1

  if number1 < number2 then return 1

  else then return 0

is_special_str = (str) ->

  if (((R.type str) is \String) and (str[0] is ":"))

    return true

  else return false

flatro.array = (msg,fin) ->

  for I in msg

    switch R.type I

    | \String,\Number =>

      fin.push I

    | \Array  =>

      uno = I[0]

      if is_special_str uno

        fin.push I

      else

        flatro.array I,fin

rm_not_arrays = R.filter (x) -> ((R.type x) is \Array)

flatro.main = (msg) ->

  out = switch R.type msg

  | \String   => [msg]

  | \Array    =>

    fin = []

    if is_special_str msg[0]

      msg = [msg]

    flatro.array msg,fin

    fin

  | otherwise => []

  clean = rm_not_arrays out

  if (clean.length is 0)

    return [[void,out]]

  else

    sorted = clean.sort flatro.sort

    return sorted

# -----------------------------------

be.any = be -> true

be.tap = (f) -> be.any.tap f

# # -----------------------------------

be.flatro = flatro.main

# # -----------------------------------

pkg = {}

pkg.types = be

pkg.guard = xop

pkg.internal = com

pkg = Object.freeze pkg

module.exports = pkg

