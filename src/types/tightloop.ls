pc = require "./print.common"

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

{com,pkgname,sig} = pc

{l,z,R,j,flat,pad,alpha_sort,esp,c,lit,create_stack} = com

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

sanatize = (x,UFO) ->

  switch R.type UFO

  | \Boolean,\Null,\Undefined,\Number =>

    if UFO
      return (continue:true,error:false,value:x)
    else
      return (continue:false,error:true,value:x,message:undefined)

  | \Array =>

    [cont,unknown,path] = UFO

    if cont

      return (continue:true,error:false,value:x)

    else

      switch R.type path
      | \Array =>
        npath = path
      | \String,\Number =>
        npath = [path]
      | otherwise =>
        npath = []

      return {
        continue :false
        error    :true
        value    :x
        message  :unknown
        path     :npath
      }

  | otherwise =>

    return {
      continue : false
      error    : true
      value    : x
      message  : "[#{pkgname}][typeError][user-supplied-validator] undefined return value."
    }

apply = {}
  ..normal = {}
    ..key = null
    ..top = null
  ..auth = {}
    ..key = null
    ..top = null


blunder = (fun,put,args) ->

  [patt,F] = fun

  switch patt
  | \err =>

    data = switch typeof F
    | \function => apply.normal.key F,put.message,args,put.path
    | otherwise => F

    # ----------------------------------

    switch R.type data

    | \Array,\String,\Number =>

      put.message = data

    | \Object =>

      if (data.hasOwnProperty \message)

        put.message = data.message

      if (data.hasOwnProperty \path)

        put.path = data.path

    | \Null =>

      put.message = void

  | \fix =>

    put.value = switch typeof F
    | \function => apply.normal.key F,put.value,args,put.path
    | otherwise => F

    put.continue = true
    put.error    = false

  | otherwise => void

  put


apply.normal.key = (F,val,args,key) ->

  switch args.length
  | 1 => F val,key
  | 2 => F val,key,args[1]
  | 3 => F val,key,args[1],args[2]
  | 4 => F val,key,args[1],args[2],args[3]
  | 5 => F val,key,args[1],args[2],args[3],args[4]
  | 6 => F val,key,args[1],args[2],args[3],args[4],args[5]
  | 7 => F val,key,args[1],args[2],args[3],args[4],args[5],args[6]
  | otherwise =>

    list = Array.prototype.slice.call args

    A = list.splice 1,0,key

    F ...A

apply.normal.top = (F,val,args) ->

  switch args.length
  | 1 => F val
  | 2 => F val,args[1]
  | 3 => F val,args[1],args[2]
  | 4 => F val,args[1],args[2],args[3]
  | 5 => F val,args[1],args[2],args[3],args[4]
  | 6 => F val,args[1],args[2],args[3],args[4],args[5]
  | 7 => F val,args[1],args[2],args[3],args[4],args[5],args[6]
  | otherwise =>

    A = Array.prototype.slice.call args

    A.shift!

    A.unshift val

    F ...A


apply.auth.top = (F,val,args) ->

  switch args.length
  | 1 => F.auth val
  | 2 => F.auth val,args[1]
  | 3 => F.auth val,args[1],args[2]
  | 4 => F.auth val,args[1],args[2],args[3]
  | 5 => F.auth val,args[1],args[2],args[3],args[4]
  | 6 => F.auth val,args[1],args[2],args[3],args[4],args[5]
  | 7 => F.auth val,args[1],args[2],args[3],args[4],args[5],args[6]
  | otherwise =>

    A = Array.prototype.slice.call args

    A.shift!

    A.unshift val

    F.auth ...A

apply.auth.key = (F,val,args,key) ->

  switch args.length
  | 1 => F.auth val,key
  | 2 => F.auth val,key,args[1]
  | 3 => F.auth val,key,args[1],args[2]
  | 4 => F.auth val,key,args[1],args[2],args[3]
  | 5 => F.auth val,key,args[1],args[2],args[3],args[4]
  | 6 => F.auth val,key,args[1],args[2],args[3],args[4],args[5]
  | 7 => F.auth val,key,args[1],args[2],args[3],args[4],args[5],args[6]
  | otherwise =>

    list = Array.prototype.slice.call args

    A = list.splice 1,0,key

    F.auth ...A

exec-key = (type,F,val,args,key) ->

  switch type
  | \d => apply.normal.key F,val,args,key
  | \i => apply.auth.key F,val,args,key
  | \f => sanatize do
    val
    apply.normal.key F,val,args,key

exec-top = (type,F,val,args) ->

  switch type
  | \d => apply.normal.top F,val,args
  | \i => apply.auth.top F,val,args
  | \f => sanatize do
    val
    apply.normal.top F,val,args

map = (dtype,fun,value,args) ->

  [type,F] = fun

  switch dtype

  | \arr =>

    I = 0

    In = value.length

    put = null

    arr = []

    while I < In

      put = exec-key type,F,value[I],args,I

      if put.error

        if put.path
          path = put.path
        else
          path = []

        return {
          continue:false
          error:true
          value:value
          message:put.message
          path:[I,...path]
        }

      arr.push put.value

      I += 1

    {continue:true,error:false,value:arr}

  | \obj =>

    ob = {}

    put = null

    for key,val of value

      put = exec-key type,F,val,args,key

      if put.error

        if put.path
          path = put.path
        else
          path = []

        return {
          continue:false
          error:true
          value:value
          message:put.message
          path:[key,...path]
        }

      ob[key] = put.value

    {continue:true,error:false,value:ob}

forEach = (dtype,fun,value,args) ->

  [type,F] = fun

  switch dtype

  | \arr =>

    I = 0

    In = value.length

    while I < In

      exec-key type,F,value[I],args,I

      I += 1

    return {continue:true,error:false,value:value}

  | \obj =>

    for key,val of value

      exec-key type,F,val,args,key

    {continue:true,error:false,value:value}


upon = ([type,fun],value,args) ->

  switch type
  | \string =>

    [key,shape,G] = fun

    put = exec-key shape,G,value[key],args,key

    if put.path
      path = put.path
    else
      path = []

    if put.error
      return {
        continue:false
        error:true
        value:value
        message:put.message
        path:[key,...path]
      }

    value[key] = put.value

    {continue:true,error:false,value:value}

  | \array =>

    [arr,shape,G] = fun

    I = 0

    In = arr.length

    while I < In

      key = arr[I]

      put = exec-key shape,G,value[key],args,key

      if put.path
        path = put.path
      else
        path = []

      if put.error

        return {
          continue:false
          error:true
          value:value
          message:put.message
          path:[key,...path]
        }

      value[key] = put.value

      I += 1

    {continue:true,error:false,value:value}

  | \object =>

    I  = 0

    In = fun.length

    while I < In

      [key,shape,G] = fun[I]

      exec-key shape,G,value[key],args,key

      if put.path
        path = put.path
      else
        path = []

      if put.error
        return {
          continue:false
          error:true
          value:value
          message:put.message
          path:[key,...path]
        }

      value[key] = put.value

      I += 1

    {continue:true,error:false,value:value}


resolve = (fun,put,dtype,args) ->

  [type,F] = fun

  {value}  = put

  switch type
  | \d => apply.normal.top F,value,args
  | \i => apply.auth.top F,value,args
  | \f => sanatize do
    value
    apply.normal.top F,value,args

  # ------------------------------------------------------

  | \map           => map dtype,F,value,args

  | \forEach       => forEach dtype,F,value,args

  | \on            => upon F,value,args

  | \cont,\edit    =>

    put.value   = switch typeof F
    | \function => apply.normal.top F,value,args
    | otherwise => F

    put

  | \tap         =>

    apply.normal.top F,value,args

    put

  | \jam       =>

    put.message  = switch typeof F

    | \function  => apply.normal.top F,value,args

    | otherwise  => F

    put.continue = false

    put.error    = true

    return put

  | \alt          =>

    I          = 0

    nI         = F.length

    do

      [type,G] = F[I]

      put = exec-top type,G,value,args

      if put.continue
        return put

      I += 1

    while I < nI

    return put

  | otherwise => put


tightloop = (x) !->

  state      = @[sig]

  {all,type} = state

  I          = 0

  put        = {continue:true,error:false,value:x}

  nI         = all.length

  while I < nI

    each = all[I]

    switch I%2

    | 0 => # and

      J  = 0

      nJ = each.length

      do

        fun = each[J]

        if put.error

          put = blunder fun,put,arguments

        else

          put = resolve fun,put,type,arguments


        J += 1

      while J < nJ

      if put.error

        I += 1

      else

        I += 2

    | 1 => # or

      J    = 0

      nJ   = each.length

      put.message = [put.message]

      do

        fun = each[J]

        [patt] = fun

        nput = resolve fun,put,type,arguments

        if nput.continue and (patt is \alt)

          put = nput
          J   = nJ

        else if nput.continue

          put = nput
          I   = nI # end entire loop
          J   = nJ

        else

          if not (nput.message is undefined)

            put.message.push nput.message

          J += 1

      while J < nJ

      I += 1

  return put


module.exports = tightloop




