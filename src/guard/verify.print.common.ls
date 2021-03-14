ext                     = require "./print.common"

{com,print,modflag}     = ext

{z,R,common_symbols,zj} = com

htypes                  = com.common_symbols.htypes

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

V.ar = (args) ->

  if (args.length > 2)
    return [\fault,\many_args]

  if (args.length < 2)
    return [\fault,\few_args]

  [num,fun] = args

  ret = []

  switch V.num num
  | \num          => ret.push array2obj [num]
  | \array        => ret.push array2obj num
  | \fault        => return [\fault,\first]
  | \fault.array  => return [\fault,\array]

  switch customTypeoOf fun
  | \Function     => ret.push [\f,fun]
  | \htypes       => ret.push [\v,fun]
  | otherwise     => ret.push [\s,fun]

  [\ok,ret]

V.wh = (args) ->

  if (args.length > 2)
    return [\fault,\many_args]

  if (args.length < 2)
    return [\fault,\few_args]

  [validator,ap] = args

  ret = []

  switch customTypeoOf validator
  | \Function   => ret.push [\f,validator]
  | \htypes     => ret.push [\v,validator]
  | otherwise   => return [\fault,\first]

  switch customTypeoOf ap
  | \Function => ret.push [\f,ap]
  | \htypes   => ret.push [\v,ap]
  | otherwise => ret.push [\s,ap]

  [\ok,ret]

numfunfun = (args) ->

  [num,validator,ap] = args

  ret = []

  switch V.num num
  | \num          => ret.push array2obj [num]
  | \array        => ret.push array2obj num
  | \fault        => return [\fault,\first]
  | \fault.array  => return [\fault,\array]

  switch customTypeoOf validator
  | \Function     => ret.push [\f,validator]
  | \htypes       => ret.push [\v,validator]
  | otherwise     => return [\fault,\second]

  type = customTypeoOf ap

  switch type
  | \Function     => ret.push [\f,ap]
  | otherwise     => ret.push [\s,ap]

  [\ok,ret]

V.arwh = (args) ->

  if (args.length > 3)
    return [\fault,\many_args]

  if (args.length < 3)
    return [\fault,\few_args]

  numfunfun args

identity = -> false

V.arpar = (args) ->

  if (args.length < 3)
    return [\fault,\few_args]

  if (args.length > 4)
    return [\fault,\many_args]

  [cont,data] = numfunfun args

  if (cont is \fault) then return ret

  ret = data

  arg4 = args[3]

  switch R.type arg4
  | \Function        => ret.push arg4
  | \Undefined,\Null => ret.push identity
  | otherwise        => return [\fault,\fourth]

  fin = [\ok,ret]

  fin


V.getvfun = (fname) ->

  switch fname

  | \wh,\whn,\ma                      => V.wh

  | \ar,\arn                          => V.ar

  | \def                              => V.def

  | \arpar                            => V.arpar

  | \arwh,\arnwh,\arwhn,\arnwhn,\arma => V.arwh
