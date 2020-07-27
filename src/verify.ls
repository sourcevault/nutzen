com = require "./common"

reg = require "./registry"

{z,R} = com

{verify} = reg

verify.fun = (args) ->

  if (args.length > 1)
    return [\fault,\f.many_args]

  if (args.length is 0)
    return [\fault,\f.few_args]

  if ((typeof args[0]) is \function)

    return [\ok,\f,args]

  else
    return [\fault,\f.fun]

# ----------------------------------------------------------

num = (args) ->

  if (typeof args[0] is \number)
    args[0] = [args[0]]
    return [\ok]
  else if Array.isArray args[0]
    for v,i in (args[0])
      if not ((typeof v) is \number)
        return [\fault,\array]
      return [\ok]
  else
    return [\fault,\num]

verify.numfun = (args) ->

  if (args.length > 2)
    return [\fault,\nf.many_args]

  if (args.length < 2)
    return [\fault,\nf.few_args]

  [cont,type] = num args

  switch cont
  | \fault => return [\fault,('nf.' + type)]

  if (typeof args[1] is \function)
    return [\ok,\nf,args]
  else
    return [\fault,\nf.fun]


verify.funfun = (args) ->

  if (args.length > 2)
    return [\fault,\ff.many_args]

  if (args.length < 2)
    return [\fault,\ff.few_args]

  if not (typeof args[0] is \function)
    return [\fault,\ff.first]

  if (typeof args[1] is \function)
    return [\ok,\ff,args]
  else
    return [\fault,\ff.second]

# ----------------------------------------------------------

verify.numfunfun = (args) ->

  if (args.length > 3)
    return [\fault,\nff.many_args]

  if (args.length < 3)
    return [\fault,\nff.few_args]

  [cont,type] = num args

  switch cont
  | \fault => return [\fault,('nff.' + type)]

  if not (typeof args[1] is \function)
    return [\fault,\nff.second]

  if (typeof args[2] is \function)

    return [\ok,\nff,args]

  else
    return [\fault,\nff.third]

# ----------------------------------------------------------

try_matching = R.pipe do
  (x) -> [x]
  R.ap [verify.numfun,verify.funfun,verify.numfunfun,verify.fun]
  R.reject ([state]) -> (state is \fault)

# ----------------------------------------------------------


map_fname = (fname) ->

  shorthand = switch fname
  | \wh,\when                                    => \wh
  | \whn,\when_not                               => \whn
  | \ar,\arg,\args                               => \ar
  | \arn,\arg_not,\args_not                      => \arn
  | \arwh,\arg_when,\args_when                   => \arwh
  | \arwhn,\arg_when_not,\args_when_not          => \arwhn
  | \arnwhn,\arg_not_when_not,\args_not_when_not => \arnwhn
  | \def,\default                                => \def
  | otherwise                                    => \fault

  switch shorthand
  | \fault => return [\fault,\path,\api_not_defined,fname]

  V = verify

  validator = switch shorthand
  | \wh       => V.funfun
  | \whn      => V.funfun
  | \ar       => V.numfun
  | \arn      => V.numfun
  | \arwh     => V.numfunfun
  | \arwhn    => V.numfunfun
  | \arnwhn   => V.numfunfun
  | \def      => V.fun

  [\ok,shorthand,validator]

# ----------------------------------------------------------

verify.main = (path,args,data) ->

  switch path.length
  | 0 =>

    if (data.fns.length is 0) and (data.def is null)

      rets = try_matching args

      switch rets.length
      | 0         => return [\fault,\path,\all_match_fail]
      | otherwise =>
        [[_,patt,clean_args]] = rets
        switch patt
        | \f  => [\ok,\def,clean_args]
        | \nf  => [\ok,\ar,clean_args]
        | \ff  => [\ok,\wh,clean_args]
        | \nff => [\ok,\arwh,clean_args]

    else

      return [\ok,\resolve,args]

  | 1 =>

    ret = map_fname path[0]

    [cont,fname,validator] = ret

    switch cont
    | \fault => return ret

    ret = validator args

    [cont,errorType,clean_args] = ret

    switch cont
    | \fault => return [\fault,\input,fname,errorType]

    switch fname
    | \def =>
      switch data.ldef
      | true  => return [\fault,\path,\def_is_defined]

    return ['ok',fname,clean_args]

  | otherwise => [\fault,\path,\path_too_long,path]




