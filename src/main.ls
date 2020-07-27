com = require "./common"

require "./verify"

require "./print"

{binapi,l,SI,z,reg,noop,sim,j} = com

{verify,printE} = reg

merge = (data,p) -> SI.merge data,p,(merger:sim.concatArrayMerger)

resolve = (data,input) !->

  arglen = input.length

  for [fname,args] in data.fns

    switch fname

    | \ar =>

      [lens,f] = args

      for I in lens
        if (arglen is I)
          return f ...input

    | \arn =>

      [lens,f] = args

      for I in lens
        if not (arglen is I)
          return f ...input

    | \wh =>

      [validator,f] = args

      if (validator ...input)
        return f ...input

    | \whn =>

      [validator,f] = args

      if not (validator ...input)
        return f ...input

    | \arwh     =>

      [lens,validator,f] = args

      for I in lens
        if (arglen is I)
          if (validator ...input)
            return f ...input

    | \arwhn    =>

      [lens,validator,f] = args

      for I in lens
        if (arglen is I)
          if not (validator ...input)
            return f ...input

    | \arnwhn    =>

      [lens,validator,f] = args

      for I in lens
        if not (arglen is I)
          if not (validator ...input)
            return f ...input

  if data.def

    return data.def ...input


main = (data,fname,args) ->

  switch fname
  | \resolve  => return resolve data,args

  part = {}

  part.str = [fname]

  neo = switch fname
  | \def =>

    [f] = args

    part.ldef = true
    part.def = f

    merge data,part

  | otherwise =>

    part.fns = [[fname,args]]

    merge data,part

  return binapi entry,neo


entry = (path,args,data)->

  if data.fault then return binapi entry,data

  ret = verify.main path,args,data

  [cont,fname,args] = ret

  switch cont
  | \fault    =>

    printE.route data.str,ret

    (fault:ret)
    |> merge data,_
    |> binapi entry,_

  | otherwise => main data,fname,args

entry.log = printE.log

data =
  fns:[]
  def:null
  ldef:false
  fault:false
  str:[]
  self:null

hoplon = binapi entry,(SI data)


V = hoplon.ar do
  1,(x) ->

    'run me!'


z V

