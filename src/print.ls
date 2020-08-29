reg = require "./registry"

{com,main} = reg

{z,chalk,l,pretty-error,R} = com

{modflag} = reg

print = reg.print

packageJ = reg.packageJ

c = {}
  ..ok    = chalk.green.bold
  ..er    = chalk.hex "FF0000"
  ..warn  = chalk.hex "FFFFCD"
  ..err   = chalk.red
  ..black = chalk.rgb(128, 128, 128).bold

help =
  c.black "[  docs] #{packageJ.homepage}"

# -------------------------------------------------------------------------------------------------------

pe = (new prettyError!)

pe.skipNodeFiles!

pe.filterParsedError (Error) ->

  Error._trace = R.takeLast 5,Error._trace

  Error

pe.skip (traceLine,lineNumber) ->

  if traceLine.dir is "internal/modules/cjs" then return true

  return false


pe.appendStyle do
  "pretty-error > header > title > kind":(display: "none")
  "pretty-error > header > colon":(display: "none")
  "pretty-error > header > message":(display:"none")

# -  - - - - - - - - - - - - - - - - - - - - - - - - --  - - - - - - - - - - - - - - - - - - - - - - - - -

print.log = {}

print.log.proto = -> print.log.main @[modflag]

print.log.wrap = (state) -> -> print.log.main state

print.log.main = (state) ->

  str = ""

  if state is undefined

    return [ I for I of main]

  if state.mutelog

    if state.fault
      return c.err "[error.#{packageJ.name}]"

    if state.immutable
      return c.ok "[immutable.#{packageJ.name}]"

    else
      return c.warn "[mutable.#{packageJ.name}]"

  switch state.immutable
  | true  =>
    str += c.ok "[   immutable   ]"
  | false =>
    str += c.warn "[    mutable    ]"

  str += "\n"
  str += "-----------------"
  str += "\n"

  for {fname,data},I in state.fns

    str += c.ok '- ' + fname

    switch fname
    | \ar,\arn,\arwh,\arnwh,\arwhn,\arnwhn =>


      [spans,fdata] = data

      [type,lens] = spans

      switch type
      | \n =>
        str += c.warn ' [ ' + lens + ' ]'
      | \a =>
        str += c.warn ' [ ' + (lens.join ' ') + ' ]'

    if (I < (state.fns.length - 1))

      str += "\n"

  if state.fault

    [ECLASS,fname,type] = state.fault

    str += "\n"

    innertxt = ([ECLASS,type]).join " "

    str += c.er "- ERROR : | #{fname} | #{innertxt}"


  str += "\n"
  str += "-----------------"

  if state.def
    str +=  c.ok " \n- def"

  str
# -  - - - - - - - - - - - - - - - - - - - - - - - - --  - - - - - - - - - - - - - - - - - - - - - - - - -


show_stack = !->

  l help

  E = pe.render new Error!

  l E


print.fail = (filename) -> !->

  l do
    "[TEST ERROR] originating from module"
    "[#{packageJ.name}]"

    "\n\n- 'npm test' failed at #{filename}:"

  process.exitCode = 1


show_chain = (data,path = [],show-args = true)->

  str = ""

  for I in data.str

    str += ".#{I}(~)"

  str = c.ok str

  if show-args

    str += [ c.warn ".#{I}" for I in path].join ""

    str += c.er "(xx) <-- error within argument"

  else

    str += c.err([".#{I}" for I in path].join "")

    str += c.er " <-- error here."

  str


map_fname_to_ctypes = (fname)->

  switch fname
  | \ma                  => \ma
  | \def                 => \def
  | \ar,\arn             => \ar
  | \wh,\whn             => \wh
  | \arwh,\arwhn,\arnwhn => \arwh

StrArgLen = (fname,ctype,eType)->

  data = switch ctype
  | \ma   => [1,'function|[fun....]']
  | \def  => [1,"(function|any)"]
  | \ar   => [2,'(number|[num...],function|any)']
  | \wh   => [2,'(function,function|any)']
  | \arwh => [3,'(number|[num...],function,function|any)']

  switch eType
  | \many_args =>
    [
      "too many arguments"
      c.er "xx"
      """
        only #{data[0]} arguments accepted

        type :: #{data[1]}
      """
    ]
  | \few_args  =>
    [
      "too few arguments"
      c.er "xx"
      """
        requires #{data[0]} arguments

        type : #{data[1]}
      """
    ]


StrEType = (fname,eType) ->

  ctype = map_fname_to_ctypes fname

  switch eType
  | \many_args,\few_args => return StrArgLen fname,ctype,eType


  parts = switch ctype
  | \ma =>
      [
        c.er('function|[fun....]')
        c.er('xx')
      ]
  | \def =>
      [
        c.er('function|any')
        c.er('fun')
      ]

  | \ar =>
    switch eType
    | \first =>
      [
        c.er("number") + c.ok('|[num...],function|any')
        c.er('num') + c.ok('|[num...],fun|any')
      ]
    | \array =>
      [
        c.ok("number") + c.er('|[num..]') + c.ok(',function|any')
        c.er('[num..]') + c.ok(',fun|any')
      ]

  | \wh =>
    switch eType
    | \first =>
      [
        c.er('function') + c.ok(',function|any')
        c.er('fun') + c.ok(',fun|any')
      ]
    | \second =>
      [
        c.ok('function,') + c.er('function|any')
        c.ok('fun,') + c.er('fun|any')
      ]
  | \arwh =>
    switch eType
    | \num =>
      [
        c.er('number') + c.ok('|[num..],function,function|any')
        c.er('num') + c.ok(',fun,fun|any')
      ]

    | \array =>
      [
        c.ok('number|') + c.er('[num..]') + c.ok(',function,function|any')
        c.er('[num..]') + c.ok(',fun,fun|any')
      ]

    | \second =>
      [
        c.ok('number[num..],') + c.er("function") + c.ok(",function|any")
        c.ok('num|[num..],')    + c.er("fun")      + c.ok(',fun|any')
      ]

  parts[0] = (c.ok("(") + parts[0] + c.ok(")"))

  parts.push 'One of the argument cannot be used by the function'

  parts


print.typeError = (data,fname,attribute) ->


  [long,short,type] = StrEType fname,attribute

  l c.err """
    [#{packageJ.name}][typeError] #{long}
    """

  ePart = c.warn('.' + fname) + c.warn("(") + short + c.warn(")") + c.warn(" <-- error here")

  l do
    '\n'
    (show_chain data,[fname])
    '\n'

  l ((c.black type) + "\n")

  show_stack!


print.route = ([Er,data]) !->

  [ECLASS,whichE,info] = Er

  switch ECLASS
  | \input =>

    [ __, fname , arg_placement ] = Er

    print.typeError do
      data
      fname
      arg_placement


  | otherwise => l Er


