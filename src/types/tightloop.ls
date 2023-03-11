pc = require \./print.common

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

{com,pkgname,print} = pc

{l,z,R,j,flat,pad,alpha_sort,esp,c,lit,create_stack} = com

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

sanatize = (x,UFO) ->

  switch R.type UFO

  | \Boolean,\Null,\Undefined,\Number =>

    if UFO
      return (continue:true,error:false,value:x)
    else
      return (continue:false,error:true,value:x)

  | \Array =>

    if UFO[0]

      return (continue:true,error:false,value:x)

    else

      unknown = UFO[1]
      path    = UFO[2]

      von =
        *continue :false
         error    :true
         value    :x
         message  :unknown

      switch R.type path
      | \Array =>
        von.path = path
      | \String,\Number =>
        von.path = [path]

      return von

  | \Object =>

    switch UFO.continue
    | true  =>
      UFO.error = false
    | false =>
      UFO.error = true

    switch UFO.error
    | true  =>
      UFO.continue = false
    | false =>
      UFO.continue = true

    return UFO

  | otherwise =>

    msg = "[#{pkgname}][typeError][user-supplied-validator] undefined return value."

    return
      *continue : false
       error    : true
       value    : x
       message  : msg

apply = {}
  ..normal = {}
    ..key = null
    ..top = null
  ..auth = {}
    ..key = null
    ..top = null

red = (fun,cond,args) ->

  [patt,F] = fun

  put = {...cond}

  switch patt
  | \err =>

    data = switch typeof F
    | \function => apply.normal.err F,args,cond
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

    put = {continue:true,error:false}

    put.value = switch typeof F
    | \function => apply.normal.key F,cond.value,args,cond.path
    | otherwise => F

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

  cond = switch type
  | \d => apply.normal.key F,val,args,key
  | \i => apply.auth.key F,val,args,key
  | \f => sanatize do
    val
    apply.normal.key F,val,args,key

  if cond.error
    if cond.path
      cond.path = [key] ++ cond.path
    else
      cond.path = [key]

    cond.value = val

  cond

lopy = {}

lopy.fix_num = (A,num) ->

  value = void

  len = A.length

  if num is -Infinity

    value = 0

  else if num is Infinity

    value = len

  else if num < 0

    mid = len + num

    value = mid

    if mid < 0

      value = 0

  else

    value = num

  return value

lopy.reverse = (to_add,user_array,start,end,step,[type,F],args)->

  I = start

  len = end - 1

  arr = new Array(...user_array)

  while I > len

    cond = exec_key type,F,user_array[I],args,I

    if to_add

      if cond.error

        cond.value = user_array

        return cond

      arr[I] = cond.value

    I -= step

  {continue:true,error:false,value:arr}

lopy.forward = (to_add,user_array,start,end,step,[type,F],args)->

  I = start

  arr = new Array(...user_array)

  len = end + 1

  while I < len

    cond = exec_key type,F,user_array[I],args,I

    if to_add

      if cond.error

        cond.value = user_array

        return cond

      arr[I] = cond.value

    I += step

  {continue:true,error:false,value:arr}

lopy.main = (to_add,fun,user_array,args) ->

  [[u_start,u_end,step],F] = fun

  start = @fix_num user_array,u_start

  end = @fix_num user_array,u_end

  if step < 0

    step = Math.abs step

    cond = @reverse to_add,user_array,start,end,step,F,args

  else

    cond = @forward to_add,user_array,start,end,step,F,args

  return cond

functor_EMsg = "[#{pkgname}][runtimeError] most likely due to changing mappable object to non-mappable one."

map = (dtype,fun,udata,args) ->

  if (typeof (udata)) isnt \object

    return {continue:false,error:true,message:functor_EMsg}

  switch dtype

  | \arr =>

    lopy.main true,fun,udata,args

  | \obj =>

    [[type,F]] = fun

    ob = {}

    cond = null

    for key,val of udata

      cond = exec_key type,F,val,args,key

      if cond.error

        return cond

      ob[key] = cond.value

    {continue:true,error:false,value:ob}

forEach = (dtype,fun,udata,args) ->

  if (typeof (udata)) isnt \object

    return {continue:false,error:true,message:functor_EMsg}

  cond = {continue:true,error:false,value:udata}

  switch dtype

  | \arr =>

    lopy.main false,fun,udata,args

  | \obj =>

    [[type,F]] = fun

    for key,val of value

      exec_key type,F,val,args,key

  cond

upon = ([type,fun],value,args) ->

  if (typeof (value)) isnt \object

    return {continue:false,error:true,message:functor_EMsg}

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

green = (fun,cond,dtype,args) ->

  [type,F] = fun

  value  = cond.value

  ncond = switch type
  | \d => apply.normal.top F,value,args
  | \i => apply.auth.top F,value,args
  | \f =>

    vixod = apply.normal.top F,value,args

    sanatize value,vixod

  # ------------------------------------------------------

  | \map           => map dtype,F,value,args

  | \forEach       => forEach dtype,F,value,args

  | \on            => upon F,value,args

  | \cont          =>

    cond.value   = switch typeof F
    | \function => apply.normal.top F,value,args
    | otherwise => F

    cond

  | \tap         =>

    apply.normal.top F,value,args

    cond

  | \jam         =>

    put = {continue:false,error:true}

    put.message  = switch typeof F

    | \function  => apply.normal.top F,value,args

    | otherwise  => F

    put

  | otherwise => cond

  if ncond.error

    ncond.value = value

  ncond

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

  # --- done ---

  fin.type = self.type

  fin

tightloop = (x) !->

  if not @data

    self = @self

    von = self_amorty self

    @data = von

  # ----------------------

  data = @data

  dtype = data.type

  I = 0

  olen = data.length

  cond = {continue:true,error:false,value:x}

  # ----------------------

  :oloop do

    cd = data[I]

    {type,item} = cd

    I += 1

    switch cd.type
    | \and =>

      if cond.error

        cond = red item,cond,arguments

      else

        cond = green item,cond,dtype,arguments

    | \and.multi  =>

      K = 0

      ilen = item.length

      do

        fun = item[K]

        if cond.error

          cond = red fun,cond,arguments

        else

          cond = green fun,cond,dtype,arguments

        K += 1

      while K < ilen

    | \or,\alt =>

      if not cond.error then continue oloop

      cond.message = [cond.message]

      ncond = green item,cond,dtype,arguments

      if ncond.error

        if (ncond.message isnt void)

          cond.message.push ncond.message

      else

        cond = ncond

        if type is \or
          break oloop

    | \or.multi,\alt.multi =>

      if (not cond.error) then continue oloop

      J = 0

      ilen = item.length

      cond.message = [cond.message]

      do

        fun = item[J]

        ncond = green fun,cond,dtype,arguments

        if ncond.error

          if (ncond.message isnt void)

            cond.message.push ncond.message

          J += 1

        else

          cond = ncond

          if type is \or
            break oloop

      while J < ilen

    | \try       =>

      if cond.error then continue oloop

      end = cd.end

      start_cond = cond

      K = 0

      klen = item.length

      el = []

      :kloop do

        eachTry = item[K]

        K += 1

        jlen = eachTry.length

        J = 0

        :jloop do

          fun = eachTry[J]

          J += 1
 
          if cond.error

            cond = red fun,cond,arguments

          else

            cond = green fun,cond,dtype,arguments

        while J < jlen

        if cond.continue

          break kloop

        el.push cond.message

        if (K < klen)

          cond = start_cond

      while K < klen

      if cond.error

        cond.message = el.reverse!

        cond.value = start_cond.value

  while I < olen

  return cond


module.exports = tightloop

