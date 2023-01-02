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

    if not (Number.isInteger Number index)
      continue

    switch R.type item
    | \Array     =>
      a_item = item
    | \Function  =>
      a_item = [item]
    | otherwise  => return [\fault,[\ob_inner_array,index]]

    if Array.isArray a_item[0]
      clean = a_item
    else
      clean = [a_item]

    tup = []

    for k from 0 til clean.length

      item_inner = clean[k]

      id = fun2map item_inner

      if id[0] is \fault then return [\fault,[id[1],(index+'.'+k)]]

      tup.push id

    ret[index] = tup

  [\ok,[\ob,ret]]

fun2map = {}

fun2map.arwh_ob = (item_inner) ->

  if not (Array.isArray item_inner)

    return [\fault,\ob_inner_not_array]

  switch item_inner.length
  | 1 =>

    [whatdo] = item_inner

    validator = void

  | otherwise =>

    [validator,whatdo] = item_inner

  tup = []

  switch customTypeoOf validator

  | \Function     => tup.push [\f,validator]
  | \htypes       => tup.push [\v,validator]
  | \Undefined    => tup.push [\b,true]
  | \Boolean      => tup.push [\b,validator]
  | otherwise     => return [\fault,\ob_inner_array_validator]

  switch customTypeoOf whatdo

  | \Function     => tup.push [\f,whatdo]
  | \htypes       => tup.push [\v,whatdo]
  | otherwise     => tup.push [\s,whatdo]

  tup

ret_void = -> void

fun2map.arpar_ob = (item_inner) ->

  if not (Array.isArray item_inner)
    return [\fault,\ob_inner_not_array]

  switch item_inner.length
  | 1 =>
    [whatdo] = item_inner
    validator = true
    lastview  = ret_void
  | 2 =>
    [lastview,whatdo] = item_inner
    validator = true
  | otherwise =>
    [validator,lastview,whatdo] = item_inner

  tup = []

  switch customTypeoOf validator

  | \Function     => tup.push [\f,validator]
  | \htypes       => tup.push [\v,validator]
  | \Undefined    => tup.push [\b,true]
  | \Boolean      => tup.push [\b,validator]
  | otherwise     => return [\fault,\ob_inner_array_validator]


  switch R.type lastview
  | \Function        => tup.push lastview
  | otherwise        => return [\fault,\ob_inner_lastview]

  switch customTypeoOf whatdo

  | \Function     => tup.push [\f,whatdo]
  | \htypes       => tup.push [\v,whatdo]
  | otherwise     => tup.push [\s,whatdo]

  tup

V.arwh_ob = (ob) ->

  multi_object fun2map.arwh_ob,ob

V.ar_ob = (ob)->

  if not ((customTypeoOf ob) is \Object)

    return [\fault,[\ar_ob_not_object]]

  ret = {}

  for index,item of ob

    if not (Number.isInteger Number index)
      continue

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

  if (args.length < 2)
    return [\fault,[\few_args]]

  if (args.length > 4)
    return [\fault,[\many_args]]


  switch args.length
  | 2 =>
    [raw_num,whatdo] = args
    validator = true
    lastview = ret_void
  | 3 =>
    [raw_num,validator,whatdo] = args
    lastview = ret_void
  | 4 =>
    [raw_num,validator,lastview,whatdo] = args

  switch V.num raw_num
  | \num          =>
    type = \n
    num = raw_num
  | \array        =>
    type = \a
    num = array2obj raw_num
  | \fault        => return [\fault,[\first]]
  | \fault.array  => return [\fault,[\array]]

  ret = []

  switch customTypeoOf validator
  | \Function     => ret.push [\f,validator]
  | \htypes       => ret.push [\v,validator]
  | \Undefined    => ret.push [\b,true]
  | \Boolean      => ret.push [\b,validator]
  | otherwise     => return [\fault,[\second]]

  switch customTypeoOf lastview
  | \Function     => ret.push lastview
  | otherwise        => return [\fault,\ob_inner_lastview]

  switch customTypeoOf whatdo
  | \Function     => ret.push [\f,whatdo]
  | otherwise     => ret.push [\s,whatdo]

  out = 
    *\ok
     *type
       *num
        ret

  out


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
