ext                             = require "./print.common"

{com,print,modflag}             = ext

{z,R,common_symbols,zj,version} = com

htypes                          = com.common_symbols.htypes

V = {}

export {...ext,verify:V}

customTypeoOf = (unknown) ->

  type = R.type unknown

  switch type

  | \Object,\Function =>

    if unknown[htypes] then return \htypes

    return type

  | otherwise => return type

V.def = (args) ->

  [f] = args

  switch customTypeoOf f
  | \Function => [\ok,[\f,f]]
  | \htypes   => [\ok,[\v,f]]
  | otherwise => [\ok,[\s,f]] # static


V.num = (num) ->

  switch R.type num
  | \Number => return \num
  | \Array  =>
    for v in num
      if not ((typeof v) is \number)
        return \fault.array
    return \array
  | otherwise => return \fault

array2obj = (arr)->

  ob = {}

  for I in arr

    ob[I] = true

  ob

multi_object = (fun2map,ob)->

  if not ((customTypeoOf ob) is \Object)

    return [\fault,[\ob_not_object]]

  ret = {}

  for index,item of ob

    if not (Array.isArray item) then return [\fault,[\ob_inner_array,index]]

    if Array.isArray item[0]
      clean = item
    else
      clean = [item]

    tup = []

    for k,item_inner of clean

      id = fun2map item_inner,index,k

      if id[0] is \fault then return id

      tup.push id

    ret[index] = tup

  [\ok,[\ob,ret]]

fun2map = {}

fun2map.arwh_ob = (item_inner,index,k) ->

  if not (Array.isArray item_inner)
    return [\fault,[\ob_inner_not_array,(index+'.'+k)]]

  [validator,whatdo] = item_inner

  tup = []

  switch customTypeoOf validator

  | \Function     => tup.push [\f,validator]
  | \htypes       => tup.push [\v,validator]
  | otherwise     => return [\fault,[\ob_inner_array_validator,(index+'.'+k)]]

  switch customTypeoOf whatdo

  | \Function     => tup.push [\f,whatdo]
  | \htypes       => tup.push [\v,whatdo]
  | otherwise     => tup.push [\s,whatdo]

  tup

ret_void = -> void

fun2map.arpar_ob = (item_inner,index,k) ->

  if not (Array.isArray item_inner)
    return [\fault,[\ob_inner_not_array,(index+'.'+k)]]

  [validator,whatdo,lastview] = item_inner

  tup = []

  switch customTypeoOf validator

  | \Function     => tup.push [\f,validator]
  | \htypes       => tup.push [\v,validator]
  | otherwise     => return [\fault,[\ob_inner_array_validator,(index+'.'+k)]]

  switch customTypeoOf whatdo

  | \Function     => tup.push [\f,whatdo]
  | \htypes       => tup.push [\v,whatdo]
  | otherwise     => tup.push [\s,whatdo]

  switch R.type lastview
  | \Function        => tup.push lastview
  | \Undefined       => tup.push ret_void
  | otherwise        => return [\fault,[\ob_inner_lastview,(index+'.'+k)]]

  tup

V.arwh_ob = (ob) -> multi_object fun2map.arwh_ob,ob

V.ar_ob = (ob)->

  if not ((customTypeoOf ob) is \Object)

    return [\fault,[\ar_ob_not_object]]

  ret = {}

  for index,item of ob

    to_add = switch customTypeoOf item
    | \Function     => [\f,item]
    | \htypes       => [\v,item]
    | otherwise     => [\s,item]

    ret[index] = to_add

  [\ok,[\ob,ret]]

V.ar = (fname,args) ->

  if (args.length is 1) and (fname is \ar)

    return V.ar_ob args[0]

  if (args.length > 2)
    return [\fault,[\many_args]]

  if (args.length < 2)
    return [\fault,[\few_args]]

  [num,fun] = args

  ret = []

  type = \n # num

  switch V.num num
  | \num          => ret.push num
  | \array        => 
    type = \a # num_array
    ret.push array2obj num
  | \fault        => return [\fault,[\first]]
  | \fault.array  => return [\fault,[\array]]

  switch customTypeoOf fun
  | \Function     => ret.push [\f,fun]
  | \htypes       => ret.push [\v,fun]
  | otherwise     => ret.push [\s,fun]

  [\ok,[type,ret]]

V.wh = (fname,args) ->

  if (args.length > 2)
    return [\fault,[\many_args]]

  if (args.length < 2)
    return [\fault,[\few_args]]

  [validator,ap] = args

  ret = []

  switch customTypeoOf validator
  | \Function   => ret.push [\f,validator]
  | \htypes     => ret.push [\v,validator]
  | otherwise   => return [\fault,[\first]]

  switch customTypeoOf ap
  | \Function => ret.push [\f,ap]
  | \htypes   => ret.push [\v,ap]
  | otherwise => ret.push [\s,ap]

  [\ok,ret]

numfunfun = (args) ->

  [num,validator,ap] = args

  switch V.num num
  | \num          =>
    type = \n
    val = num
  | \array        =>
    type = \a
    val = array2obj num
  | \fault        => return [\fault,[\first]]
  | \fault.array  => return [\fault,[\array]]

  ret = []

  switch customTypeoOf validator
  | \Function     => ret.push [\f,validator]
  | \htypes       => ret.push [\v,validator]
  | otherwise     => return [\fault,[\second]]

  switch customTypeoOf ap
  | \Function     => ret.push [\f,ap]
  | otherwise     => ret.push [\s,ap]

  [\ok,[type,[val,ret]]]

V.arwh = (fname,args) ->

  if (args.length is 1) and (fname in [\arwh \arwhn \arma])

    return V.arwh_ob args[0]

  if (args.length < 3)
    return [\fault,[\few_args]]

  if (args.length > 3)
    return [\fault,[\many_args]]

  numfunfun args

V.arpar_ob = (ob) ->

  multi_object fun2map.arpar_ob,ob

V.arpar = (fname,args) ->

  if (args.length is 1)

    return V.arpar_ob args[0]

  if (args.length < 3)
    return [\fault,[\few_args]]

  if (args.length > 4)
    return [\fault,[\many_args]]

  [cont,data] = numfunfun args

  if (cont is \fault) then return ret

  arg4 = args[3]

  ret = data[1][1]

  switch R.type arg4
  | \Function        => ret.push arg4
  | \Undefined       => ret.push ret_void
  | otherwise        => return [\fault,[\fourth]]

  [\ok,data]

V.par = (fname,args) ->

  if (args.length < 3)
    return [\fault,[\few_args]]

  if (args.length > 3)
    return [\fault,[\many_args]]

  [validator,ap,lastview] = args

  ret = []

  switch customTypeoOf validator
  | \Function     => ret.push [\f,validator]
  | \htypes       => ret.push [\v,validator]
  | otherwise     => return [\fault,[\validator]]

  type = customTypeoOf ap

  switch type
  | \Function     => ret.push [\f,ap]
  | otherwise     => ret.push [\s,ap]

  switch customTypeoOf lastview
  | \Function     => ret.push lastview
  | otherwise     => return [\fault,[\lastview]]

  [\ok,ret]


V.getvfun = (fname) ->

  switch fname

  | \wh,\whn,\ma                      => V.wh

  | \ar,\arn                          => V.ar

  | \def                              => V.def

  | \arpar                            => V.arpar

  | \par                              => V.par

  | \arwh,\arnwh,\arwhn,\arnwhn,\arma => V.arwh
