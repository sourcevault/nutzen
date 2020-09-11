reg = require "./registry"

{com,verify,print,sig} = reg

{z,R} = com

V = verify

betterTypeof = (x) ->

  type = typeof x

  if (type is \object)
    if (Array.isArray x)
      return \array
    else if (x is null)
      return \null
    else
      return \object
  else
    return type


reg.betterTypeof = betterTypeof

V.def = (args) ->

  [f] = args

  switch betterTypeof f
  | \function => [\ok,[\f,f]]
  | otherwise => [\ok,[\s,f]] # static

V.num = (num) ->

  if (typeof num is \number)
    return \num
  else if Array.isArray num
    for v in num
      if not ((typeof v) is \number)
        return \fault.array
    return \array
  else
    return \fault


tron = (arr)->

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
  | \num          => ret.push tron [num]
  | \array        => ret.push tron num
  | \fault        => return [\fault,\first]
  | \fault.array  => return [\fault,\array]

  switch betterTypeof fun
  | \function     => ret.push [\f,fun]
  | otherwise     => ret.push [\s,fun]

  [\ok,ret]

V.wh = (args) ->

  if (args.length > 2)
    return [\fault,\many_args]

  if (args.length < 2)
    return [\fault,\few_args]

  [validator,ap] = args

  ret = []

  switch betterTypeof validator
  | \function => ret.push validator
  | otherwise => return [\fault,\first]

  switch betterTypeof ap
  | \function => ret.push [\f,ap]
  | otherwise => ret.push [\s,ap]

  [\ok,ret]


V.ma = (arg-obj) ->

  args = [...arg-obj]

  if (args.length is 0)
    return [\fault,\few_args]

  args = R.flatten args

  ret = []

  for I in args
    switch betterTypeof I
    | \function => ret.push I
    | otherwise => return [\fault,\typeError]

  [\ok,ret]

V.arma = (arg-obj) ->

  args = [...arg-obj]

  if (args.length < 2)

    return [\fault,\few_args]

  ret = []

  num  = R.head args

  funs = R.tail args

  retF = []

  switch V.num num
  | \num          => ret.push tron [num]
  | \array        => ret.push tron num
  | \fault        => return [\fault,\first]
  | \fault.array  => return [\fault,\array]

  funs = R.flatten funs

  retF = []

  for F in funs

    switch betterTypeof F
    | \function   => retF.push F
    | otherwise   => return [\fault,\not_function]

  ret.push retF

  [\ok,ret]


V.arwh = (args) ->

  if (args.length > 3)
    return [\fault,\many_args]

  if (args.length < 3)
    return [\fault,\few_args]

  [num,validator,ap] = args

  ret = []

  switch V.num num
  | \num          => ret.push tron [num]
  | \array        => ret.push tron num
  | \fault        => return [\fault,\first]
  | \fault.array  => return [\fault,\array]

  switch betterTypeof validator
  | \function     => ret.push validator
  | otherwise     => return [\fault,\second]

  type = betterTypeof ap

  switch type
  | \function     => ret.push [\f,ap]
  | otherwise     => ret.push [\s,ap]

  [\ok,ret]

V.getvfun = (fname) ->

  switch fname

  | \wh,\whn                    => V.wh

  | \ar,\arn                    => V.ar

  | \arma                       => V.arma

  | \arwh,\arnwh,\arwhn,\arnwhn => V.arwh

  | \ma                         => V.ma

  | \def                        => V.def




