pc = require \./print.common

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

{com,pkgname} = pc

{l,z,R,j,flat,pad,alpha_sort,esp,c,lit,create_stack} = com

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

sanatize = (x,UFO) ->

  switch R.type UFO

  | \Boolean,\Null,\Undefined,\Number =>

    if UFO
      return (continue:true,error:false,value:x)
    else
      return (continue:false,error:true,value:x,message:void)

  | \Array =>

    if UFO[0]

      return (continue:true,error:false,value:x)

    else

      unknown = UFO[1]
      path    = UFO[2]

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

  | \Object =>

    switch UFO.continue
    | true  =>
      UFO.error = false
    | false =>
      UFO.error = true

    switch UFO.error
    | true  =>
      UFO.contiue = false
    | false =>
      UFO.contiue = true

    return UFO

  | otherwise =>

    msg = "[#{pkgname}][typeError][user-supplied-validator] undefined return value."

    return {
      continue : false
      error    : true
      value    : x
      message  : msg
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
    | \function => apply.normal.err F,args,put
    | otherwise => F

    # ----------------------------------

    switch R.type data

    | \Array,\String,\Number =>

      put.message = data

    | \Object =>

      if (data.hasOwnProperty \message)

        put.message = data.message

      if (data.hasOwnProperty \path)

        switch R.type data.path
        | \Number,\String =>
          put.path = [data.path]
        | \Array =>
          put.path = data.path

    | \Null =>

      put.message = void

  | \fix =>

    put.value = switch typeof F
    | \function => apply.normal.key F,put.value,args,put.path
    | otherwise => F

    put.continue = true
    put.error    = false
    put.message  = undefined

  | otherwise => void

  put

apply.normal.key = (F,val,args,path) ->

  switch args.length
  | 1 => F val,path
  | 2 => F val,path,args[1]
  | 3 => F val,path,args[1],args[2]
  | 4 => F val,path,args[1],args[2],args[3]
  | 5 => F val,path,args[1],args[2],args[3],args[4]
  | 6 => F val,path,args[1],args[2],args[3],args[4],args[5]
  | 7 => F val,path,args[1],args[2],args[3],args[4],args[5],args[6]
  | otherwise =>

    list = Array.prototype.slice.call args

    list.splice 1,0,path

    F ...list

apply.normal.err = (F,args,put) ->

  {message,path} = put

  switch args.length
  | 0 => F message,path
  | 1 => F message,path,args[0]
  | 2 => F message,path,args[0],args[1]
  | 3 => F message,path,args[0],args[1],args[2]
  | 4 => F message,path,args[0],args[1],args[2],args[3]
  | 5 => F message,path,args[0],args[1],args[2],args[3],args[4]
  | 6 => F message,path,args[0],args[1],args[2],args[3],args[4],args[5]
  | 7 => F message,path,args[0],args[1],args[2],args[3],args[4],args[5],args[6]
  | otherwise =>

    list = Array.prototype.slice.call args

    list.unshift message,path

    F ...list

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

\d # default
\i # instance / hoplon.types instance
\f # function / user provided function

exec_key = (type,F,val,args,key) ->

  sortir = switch type
  | \d => apply.normal.key F,val,args,key
  | \i => apply.auth.key F,val,args,key
  | \f => sanatize do
    val
    apply.normal.key F,val,args,key

  if sortir.error
    if sortir.path
      sortir.path = [key] ++ sortir.path
    else
      sortir.path = [key]

    sortir.value = val

  sortir

exec_top = (type,F,val,args) ->

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

      put = exec_key type,F,value[I],args,I

      if put.error

        return put

      arr.push put.value

      I += 1

    {continue:true,error:false,value:arr}

  | \obj =>

    ob = {}

    put = null

    for key,val of value

      put = exec_key type,F,val,args,key

      if put.error
        return put

      ob[key] = put.value

    {continue:true,error:false,value:ob}

forEach = (dtype,fun,value,args) ->

  [type,F] = fun

  switch dtype

  | \arr =>

    I = 0

    In = value.length

    while I < In

      exec_key type,F,value[I],args,I

      I += 1

    return {continue:true,error:false,value:value}

  | \obj =>

    for key,val of value

      exec_key type,F,val,args,key

    {continue:true,error:false,value:value}


upon = ([type,fun],value,args) ->

  switch type
  | \string =>

    [key,shape,G] = fun

    put = exec_key shape,G,value[key],args,key

    if put.error
      return put

    value[key] = put.value

    {continue:true,error:false,value:value}

  | \array =>

    [arr,shape,G] = fun

    I = 0

    In = arr.length

    while I < In

      key = arr[I]

      put = exec_key shape,G,value[key],args,key

      if put.error
        return put

      value[key] = put.value

      I += 1

    {continue:true,error:false,value:value}

  | \object =>

    I  = 0

    In = fun.length

    while I < In

      [key,shape,G] = fun[I]

      put = exec_key shape,G,value[key],args,key

      if put.error
        return put

      value[key] = put.value

      I += 1

    {continue:true,error:false,value:value}

  | \single_array =>

    I  = 0

    In = fun.length

    while I < In

      [type,[field_type,field],wFt,wFF] = fun[I]

      if (type is \and)

        if field_type is \S

          put = exec_key wFt,wFF,value[field],args,field

          if put.error
            return put

          value[field] = put.value

        else if field_type is \A

          for each in field

            put = exec_key wFt,wFF,value[each],args,each

            if put.error
              return put

            value[each] = put.value

      else if type is \alt

        if field_type is \S

          field = [field]

        for each in field

          put = exec_key wFt,wFF,value[each],args,each

          if put.continue
            value[each] = put.value
            break

        if put.error
          return put

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

  | \jam         =>

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

      put = exec_top type,G,value,args

      if put.continue
        return put

      I += 1

    while I < nI

    return put

  | otherwise => put

split_on_value_list = [\or,\alt,\try,\or.multi,\alt.multi]

split_on = {}

for I in split_on_value_list

  split_on[I] = true

self_amorty = (self)->

  # flatly ----------

  flaty = new Array self.index + 1

  current = self.all

  I = self.index

  while -1 < I

    flaty[I] = current.node

    current = current.back

    --I

  # flatly ----------

  fin = []

  bucket = {type:\and,item:[]}

  I =  0

  :oloop while I < flaty.length

    each = flaty[I]

    [type,data] = each

    if split_on[type]

      if bucket.item.length

        fin.push bucket

        bucket = {type:\and,item:[]}

      switch type
      | \try =>

        tbuck = {type:\try,end:false,item:[]}

        item_inner = []

        new_I = I + 1

        for K from new_I til flaty.length

          eachi = flaty[K]

          switch eachi[0]

          | \try =>

            tbuck.item.push item_inner

            item_inner = []

          | \end =>

            new_I = K + 1

            tbuck.item.push item_inner

            fin.push tbuck

            I = new_I

            tbuck.end = true

            continue oloop

          | otherwise =>

            item_inner.push eachi

          new_I++

        I = new_I

        tbuck.item.push item_inner

        fin.push tbuck

      | \or,\alt,\or.multi,\alt.multi =>

        fin.push {type:type,item:data}

    else

      bucket.item.push each

    I++

  if bucket.item.length
    fin.push bucket

  for I in fin

    if I.type isnt \and
      continue

    if I.item.length is 1

      I.item = I.item[0]

    else

      I.type = \and.multi


  # z.j fin

  # --- done ---

  fin


tightloop = (x) !->

  self = @self

  if not self.morty

    @data = self_amorty self

  # ----------------------

  data = @data

  dtype = @self.type

  I = 0

  olen = data.length

  put = {continue:true,error:false,value:x}

  # # ----------------------

  # z.j data

  # :oloop do

  #   {type,item} = data[I]


  #   switch type
  #   | \and       =>

  #     K = 0

  #     ilen = item.length

  #     do

  #       fun = item[K]

  #       if put.error

  #         put = blunder fun,put,arguments

  #       else

  #         put = resolve fun,put,dtype,arguments

  #       K++

  #     while K < ilen

  #   | \or        =>

  #     # put.message = [put.message]

  #     # K = 0

  #   | \try       =>
  #   | \alt       =>
  #   | \or.multi  =>

  #   | \alt.multi =>

  #   I++

  # while I < olen

  # return put


module.exports = tightloop

