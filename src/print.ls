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

name = packageJ.name

print.log = {}

print.log.def_fault = -> c.err "[error.#{name}]"

print.log.proto = ->

  state = @[modflag]

  if state is undefined

    return (c.er "[#{name}]") + (c.err "[state undefined]")

  print.log.main state

print.log.wrap = (state) -> -> print.log.main state

print.log.prox = (state) ->

  if state is null
    return null

  if state.lock
    return c.ok "[Function]"

  str = R.join "",["[#{name}","|",(state.vr.join "|"),"]"]

  (c.warn str) + " [ ]"

arrange = R.pipe do
  R.groupWith R.equals
  R.map do
    (x) ->
      name = x[0]
      switch x.length
      | 1          => name
      | otherwise  => name + "(" + x.length + ")"
  (x) -> c.ok (x.join " ")



print.log.main = (state) ->

  if state.fault
      return c.err "[#{name}|error]"

  str = ""

  if state.immutable
    str += "|immutable"
    clr = c.ok
  else
    str += "|mutable"
    clr = c.warn

  if state.apply
    str += "|apply"

  put = clr ("[#{name}" + str + "]")

  arr = arrange state.str


  str = put + " " + "[ " + arr + " ]"

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


show_chain = (input-str,path = [],show-args = true)->

  str = ""

  for I in input-str

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
  | \ar,\arn             => \ar
  | \wh,\whn             => \wh
  | \arwh,\arwhn,\arnwhn => \arwh
  | \arma                => \arma

StrArgLen = (fname,ctype,eType)->

  data = switch ctype
  | \ma   => [1,'function|[fun....]']
  | \wh   => [2,'(function,function|any)']
  | \arma => [2,'(number|[num...],[fun....]']
  | \ar   => [2,'(number|[num...],function|any)']
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

lit = R.pipe do
  R.zipWith (x,f) ->
    switch R.type f
    | \Function => f x
    | otherwise => x
  R.join ""

StrEType = (fname,eType) ->

  ctype = map_fname_to_ctypes fname

  switch eType
  | \many_args,\few_args => return StrArgLen fname,ctype,eType

  parts = switch ctype
  | \ma =>

      [
        c.er 'function|[fun....]'
      ]

  | \arma =>

    switch eType

    | \first =>

      lit ["number" "|[num...],[fun....]"],[c.er,c.ok]

    | \array =>

      lit ["number" "|[num..]" ",[fun....]"],[c.ok,c.er,c.ok]

    | \not_function =>

      lit ["number|[num..]",",[fun....]"],[c.ok,c.er]

  | \ar =>

    switch eType
    | \first =>

      lit ["number" "|[num...],function|any"],[c.er,c.ok]

    | \array =>

      lit ["number" "|[num..]" ",function|any"],[c.ok,c.er,c.ok]

  | \wh =>
    switch eType
    | \first =>

      lit ["function",",function|any"],[c.er,c.ok]

    | \second =>

      lit ["function","function|any"],[c.ok,c.er]

  | \arwh =>
    switch eType
    | \num =>

      lit ["number" "|[num..],function,function|any"],[c.er,c.ok]

    | \array =>

      lit ["number|" "[num..]" ",function,function|any"],[c.ok,c.er,c.ok]


    | \second =>

      lit ["number[num..],","function",",function|any"],[c.ok,c.er,c.ok]


  parts[0] = lit ["(" parts[0] ")"],[c.ok,null,c.ok]

  parts.push 'One of the argument cannot be used by the function'

  parts


print.typeError = (data,fname,attribute) ->

  [long,type] = StrEType fname,attribute

  l c.err """
    [#{packageJ.name}][typeError] #{long}
    """

  l do
    '\n'
    (show_chain data,[fname])
    '\n'

  l ((c.black type) + "\n")

  show_stack!


print.not_array = (data) ->


  l c.err """
    [#{packageJ.name}][typeError] first argument is not array like.
    """

  l do
    '\n'
    lit [\unary,(show_chain [...data.str,\def],[])],[c.warn,0]
    '\n'

  l lit ["unary namespace requires first argument to be array like.","\n"],[c.black,0]

  show_stack!


print.setting = (type,path) ->

  msg = switch type
  | \path_locked     => "all settings enabled."
  | \already_in_path => "setting already enabled."
  | \not_in_opts     => "undefined option."

  l lit ["#{name}][configError]"," #{msg}"],[c.err,c.warn]


  [vr,key] = path

  l do
    '\n'
    lit [(vr.join "."),".",key],[c.ok,c.ok,c.er]
    '\n'

  # l lit ["unary namespace requires first argument to be array like.","\n"],[c.black,0]

  show_stack!


print.route = ([Er,data]) !->

  [ECLASS,whichE,info] = Er

  switch ECLASS
  | \input   =>

    [ __, fname , arg_placement ] = Er

    print.typeError do
      data
      fname
      arg_placement

  | \not_array => print.not_array data

  | \setting => print.setting Er[1],data

  | otherwise => l Er,data


