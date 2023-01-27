utils                           = require "../../dist/utils/main.js"

ext                             = require "./print.common"

{com,print,modflag}             = ext

{z,R,version,tupnest,l}         = com

V = {}

export {...ext,verify:V}

NumIsInt = Number.isInteger

customTypeoOf = (unknown) ->

  type = R.type unknown

  switch type

  | \Object,\Function =>

    z utils.htypes.is_ins unknown
    if (utils.htypes.is_ins unknown) then return \htypes

    return type

  | \Number =>

    if (NumIsInt unknown)
      if ( unknown > -1)
        return \pos_int
      return \int

    return \Number

  | otherwise => return type


V.def = (args) ->

  [f] = args

  switch customTypeoOf f
  | \Function => [\ok,[\f,f]]
  | \htypes   => [\ok,[\v,f]]
  | otherwise => [\ok,[\s,f]] # static


V.num = (num) ->

  switch customTypeoOf num
  | \pos_int     => return \num
  | \int,\number => return \fault.num
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

isA = Array.isArray

multi_object = (fun2map,ob)->

  if not ((customTypeoOf ob) is \Object)

    return [\fault,[\ob_not_object]]

  ret = {}

  for index,item of ob

    if not (NumIsInt Number index)
      continue

    switch R.type item
    | \Array     =>
      a_item = item
    | \Function  =>
      a_item = [item]
    | otherwise  => return [\fault,[\ob.key_value_not_array,index]]

    if isA a_item[0]
      clean = a_item
    else
      clean = [a_item]

    tup = []

    for k from 0 til clean.length

      item_inner = clean[k]

      id = fun2map item_inner

      [status] = id

      if (status is \fault)

        capsule = tupnest.concat id,[index,k]

        return capsule

      tup.push id

    ret[index] = tup

  [\ok,[\ob,ret]]

fun2map = {}

fun2map.arwh_ob = (item_inner) ->

  if not (isA item_inner)

    return tupnest \fault,[\ob.inner_not_array]

  if (item_inner.length < 1)
    return tupnest \fault,[\ob.few_args]

  if (item_inner.length > 2)
    return tupnest \fault,[\ob.many_args]

  cat = item_inner.length

  switch cat
  | 1 =>

    [whatdo] = item_inner

  | 2 =>

    [validator,whatdo] = item_inner

  tup = []

  if cat is 2

    switch customTypeoOf validator

    | \Function     => tup.push [\f,validator]
    | \htypes       => tup.push [\v,validator]
    | otherwise     => return tupnest \fault,[\ob.inner_array_validator]

  switch customTypeoOf whatdo

  | \Function     => tup.push [\f,whatdo]
  | \htypes       => tup.push [\v,whatdo]
  | otherwise     => tup.push [\s,whatdo]

  tup

fun2map.arcap_ob = (item_inner) ->

  if not (isA item_inner)
    return tupnest \fault,[\ob.inner_not_array]

  if (item_inner.length < 1)
    return tupnest \fault,[\ob.few_args]

  if (item_inner.length > 3)
    return tupnest \fault,[\ob.many_args]

  switch item_inner.length
  | 1 =>
    [whatdo] = item_inner
    cat = 1
  | 2 =>
    [validator,whatdo] = item_inner
    cat = 2
  | 3 =>
    [validator,lastview,whatdo] = item_inner
    cat = 3

  tup = []

  switch customTypeoOf whatdo

  | \Function     => tup.push [\f,whatdo]
  | \htypes       => tup.push [\v,whatdo]
  | otherwise     => tup.push [\s,whatdo]

  if cat isnt 1

    switch customTypeoOf validator

    | \Function     => tup.push [\f,validator]
    | \htypes       => tup.push [\v,validator]
    | otherwise     => return tupnest \fault,\ob.inner_array_validator,[cat]


  if cat is 3

    switch R.type lastview
    | \Function        => tup.push lastview
    | otherwise        => return tupnest \fault,[\ob.inner_lastview]

  tup

V.arwh_ob = (ob) ->

  da = multi_object fun2map.arwh_ob,ob

  da

V.ar_ob = (ob)->

  if not ((customTypeoOf ob) is \Object)

    return tupnest \fault,[\ob_not_object]

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
  | \fault.num    => return [\fault,[\pos_int]]

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
  | \fault.num    => return [\fault,[\pos_int]]

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

  if (args.length is 1) and (fname in [\arwh \arwhn \arcap])

    return V.arwh_ob args[0]

  if (args.length < 3)
    return [\fault,[\few_args]]

  if (args.length > 3)
    return [\fault,[\many_args]]

  numfunfun args

V.arcap_ob = (ob) ->

  fin = multi_object fun2map.arcap_ob,ob

  fin

V.arcap = (fname,args) ->

  if (args.length is 1)

    return V.arcap_ob args[0]

  if (args.length < 2)
    return [\fault,[\few_args]]

  if (args.length > 4)
    return [\fault,[\many_args]]

  # 2,3,4
  # 1,->
    # 1,->,->
  # 1,->,->,->

  switch args.length
  | 2 =>
    [raw_num,whatdo] = args
    cat = 2
  | 3 =>
    [raw_num,validator,whatdo] = args
    cat = 3
  | 4 =>
    [raw_num,validator,lastview,whatdo] = args
    cat = 4

  switch V.num raw_num
  | \num          =>
    type = \n
    num = raw_num
  | \array        =>
    type = \a
    num = array2obj raw_num
  | \fault        => return [\fault,[\num,cat]]
  | \fault.array  => return [\fault,[\num_array,cat]]

  ret = []

  switch customTypeoOf whatdo
  | \Function     => ret.push [\f,whatdo]
  | otherwise     => ret.push [\s,whatdo]

  if cat isnt 2

    switch customTypeoOf validator
    | \Function     => ret.push [\f,validator]
    | \htypes       => ret.push [\v,validator]
    | otherwise     => return [\fault,[\validator,cat]]

  if cat is 4
    switch customTypeoOf lastview
    | \Function     => ret.push lastview
    | otherwise        => return [\fault,[\lastview,cat]]

  send = tupnest \ok,type,num,ret

  send


V.cap = (fname,args) ->

  if (args.length < 2)
    return [\fault,[\few_args]]

  if (args.length > 3)
    return [\fault,[\many_args]]

  switch args.length
  | 2 =>
    [validator,exec] = args
    cat = 2
  | 3 =>
    [validator,lastview,exec] = args
    cat = 3

  ret = []

  type = customTypeoOf exec

  switch type
  | \Function     => ret.push [\f,exec]
  | otherwise     => ret.push [\s,exec]

  switch customTypeoOf validator
  | \Function     => ret.push [\f,validator]
  | \htypes       => ret.push [\v,validator]
  | otherwise     => return [\fault,[\validator,cat]]

  if cat is 3
    switch customTypeoOf lastview
    | \Function     => ret.push lastview
    | otherwise     => return [\fault,[\lastview]]

  [\ok,ret]


V.getvfun = (fname) ->

  switch fname

  | \wh,\whn                          => V.wh

  | \ar,\arn                          => V.ar

  | \def                              => V.def

  | \arcap                             => V.arcap

  | \cap                               => V.cap

  | \arwh,\arnwh,\arwhn,\arnwhn,\arcap => V.arwh
