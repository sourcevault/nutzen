pkg = require \./print.common

internal = require \./internal

{com,print} = pkg
# ------------------------------------------------------------------

{z,l,R,j,deep_freeze,uic,loopError,noop} = com

xop = pkg.guard

{custom,define,defset} = internal

be = custom

be.known = {}

#-------------------------------------------------------------------

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

# ------------------------------------------------------

undefnull = (UFO) ->

  if ((R.type UFO) in [\Undefined \Null])

    return {continue:true,error:false,value:UFO}
  else

    return {continue:false,error:true,message:"not undefined or null",value:UFO}

defset.add undefnull

# --------------------------------------------------------

F = base \Arguments

define.basis \arg,F,\arr

define.basis.empty \arg,\arr

be.arg = F

# -----------------------------

be.not = (F) ->

  V = be F

  be (x) -> not (V.auth x).continue

# --------------------------------------------------------

# be.undefnull = be undefnull

# be.not.undefnull = be.not undefnull

# --------------------------------------------------------

# be.maybe = (F) -> ((be F).or be.undef).err (msg) -> msg.pop! ; msg

# -----------------------------

# be.list  = (F) -> be.arr.map F

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

  C = define.basis.empty name

  be.known[name] = C

#------------------------------

# for [name] in non_map_props

#   be.maybe[name] = be.maybe be[name]

# be.maybe.obj = be.obj.or be.undef

# be.maybe.arr = be.arr.or be.undef

# ------------------------------

V = be.arr

.try

.on 0,be.num

.err (arr) -> \num
.err (arr) -> \num1
.fix (x) -> x
.try

.on 1,be.str

.err (arr) -> \str
.err (arr) -> \str1


augh = V.auth []

z "---- V.auth [] ----"

z augh

augh = V.auth [1]

z "---- V.auth [1] ----"

z augh

augh = V.auth ['s']

z "---- V.auth ['s'] ----"

z augh


# V = be.known.obj
# .on do
#   *[
#     [\and,\remote,be.arr]
#     [\alt,[\remotefold,\remotehost],be.undefnull]
#    ]

# V = be.obj
# .on \remote,be.arr
# .and \remotefold,be.undef
# .cont (x)->
#   z "hello world"
# .bt 1
# .on \remotehost,be.undef


# V = be.obj
# .on do
#   *[
#     [\and,\remote,be.arr]
#     [\alt,[\remotefold,\remotehost],be.undefnull]
#    ]

# # ------------------------------------------------------------------

# not-arrayof-str-or-num = (type) -> ->

#   args = R.flatten [...arguments]

#   for key in args

#     if not ((R.type key) in [\String \Number])

#       print.route [(new Error!),\resreq,[type]]

#       return true

#   return false

# reqError = xop.wh do
#   not-arrayof-str-or-num \req
#   loopError

# resError = xop.wh do
#   not-arrayof-str-or-num \res
#   loopError

# reqresError = xop.wh do
#   (req,res) ->

#     if not (((R.type req) is "Array") and (((R.type res) is "Array")))

#       print.route [(new Error!),\resreq,[\resreq,\prime]]

#       return true

#     for I in req

#       if not ((R.type I) in [\String \Number])

#         print.route [(new Error!),\resreq,[\resreq,\res]]

#         return true

#     for I in res

#       if not ((R.type I) in [\String \Number])

#         print.route [(new Error!),\resreq,[\resreq,\req]]

#         return true


#   loopError

# #------------------------------------------------------

# objarr = (be.obj.alt be.arr).err "not object or array"

# be.required = reqError.def ->

#   props = R.flatten [...arguments]

#   ret = objarr.on props,(be.not.undef.err [\:req,props])

#   ret

# #-------------------------------------------------------------------------------------

# restricted = (props,po) -> (obj) ->

#   keys = Object.keys obj

#   for I in keys

#     if not po[I]

#       return [false,[\:res,props],I]

#   true

# be.restricted = resError.def ->

#   props = R.flatten [...arguments]

#   po = {}

#   for I in props

#     po[I] = true

#   objarr.and restricted props,po

# be.reqres = reqresError.def (req,res) ->

#   po = {}

#   for I in res

#     po[I] = true

#   objarr.on req, be.not.undef.err [\:req,req]
#   .and restricted res,po

# #-------------------------------------------------------------------------------------

# integer = (UFO) ->

#   if not ((R.type UFO) is \Number)

#     return {continue:false,error:true,message:"not an integer ( or number )",value:UFO}

#   residue = Math.abs (UFO - Math.round(UFO))

#   if (residue > 0)

#     return {continue:false,error:true,message:"not an integer",value:UFO}

#   else

#     return {continue:true,error:false,value:UFO}


# defset.add integer

# #-------------------------------------------------------------------------------------

# boolnum = (UFO) ->

#   if ((R.type UFO) in [\Boolean \Number])

#     return {continue:true,error:false,value:UFO}

#   else

#     return {continue:false,error:true,message:"not a number or boolean",value:UFO}

# defset.add boolnum

# #-------------------------------------------------------------------------------------


# maybe_boolnum = (UFO) ->

#   if ((R.type UFO) in [\Undefined \Boolean \Number])

#     return {continue:true,error:false,value:UFO}

#   else

#     return {continue:false,error:true,message:"not a number or boolean",value:UFO}


# defset.add maybe_boolnum

# #-------------------------------------------------------

# be.int     = be integer

# be.boolnum = be boolnum


# #--------------------------------------------------------

# be.int.neg  = be.int.and do
#     (x) ->
#       if (x <= 0)
#         return true
#       else
#         return [false,"not a negative integer"]

# be.int.pos  = be.int.and do
#     (x) ->
#       if (x >= 0)
#         return true
#       else
#         return [false,"not a positive integer"]

# #--------------------------------------------------------

# maybe          = be.maybe

# maybe.int      = be.int.or be.undef

# maybe.int.pos  = maybe be.int.pos

# maybe.int.neg  = maybe be.int.neg

# maybe.boolnum  = be maybe_boolnum

# #--------------------------------------------------------

# list = be.list

# list.ofstr = list be.str
# .err (msg,key)->

#   switch R.type key
#   | \Undefined => "not a list of string."
#   | otherwise  => [\:list ,[key[0],"not string type"]]

# list.ofnum = list be.num
# .err (msg,key) ->

#   switch R.type key
#   | \Undefined =>  "not a list of number."
#   | otherwise  => [\:list,[key[0],"not number type"]]

# list.ofint = list be.int
# .err (msg,key) ->

#   switch R.type key
#   | \Undefined => "not a list of integer."
#   | otherwise  => [\:list,[key[0],"not integer type"]]

# maybe.list = {}

# maybe.list.ofstr = maybe list.ofstr

# maybe.list.ofnum = maybe list.ofnum

# maybe.list.ofint = maybe list.ofint

# # -----------------------------------

# handleE = {}

# handleE.rm_num = ([txt,msg]) ->

#   name = (txt.split ":")[1]

#   if msg is void then [name]
#   else then [name,msg]


# handleE.sort = ([txt1],[txt2]) ->

#   [__,name1,number1] = txt1.split ":"

#   if (number1 is void)

#     number1 = 0

#   else

#     number1 = parseInt number1

#   [__,name2,number2] = txt2.split ":"

#   if (number2 is void)

#     number2 = 0

#   else

#     number2 = parseInt number2

#   if number1 > number2 then return -1

#   if number1 < number2 then return 1

#   else then return 0

# is_special_str = (str) ->

#   if (((R.type str) is \String) and (str[0] is ":"))

#     return true

#   else return false

# handleE.array = (msg,fin) ->

#   for I in msg

#     switch R.type I

#     | \String,\Number =>

#       fin.push I

#     | \Array  =>

#       uno = I[0]

#       if is_special_str uno

#         fin.push I

#       else

#         handleE.array I,fin

# rm-not-arrays = R.filter (x) -> ((R.type x) is \Array)

# handleE.entry = (msg) ->

#   out = switch R.type msg

#   | \String   => [msg]

#   | \Array    =>

#     fin = []

#     if is_special_str msg[0]

#       msg = [msg]

#     handleE.array msg,fin

#     fin

#   | otherwise => []

#   clean = rm-not-arrays out

#   if (clean.length is 0)

#     return [[void,out]]

#   else

#     sorted = clean.sort handleE.sort

#     return sorted

# # -----------------------------------

# betrue = be -> true

# be.any = betrue

# be.tap = (f) -> betrue.tap f

# # -----------------------------------

# be.flatro = handleE.entry

# -----------------------------------

# be = deep_freeze be

# -----------------------------------

pkg = {}

pkg.types = be

pkg.guard = xop

pkg.utils = com

pkg = Object.freeze pkg

module.exports = pkg












