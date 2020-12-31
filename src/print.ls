reg = require "./registry"

{com,main} = reg

{z,l,R,c,esp} = com

{modflag} = reg

print = reg.print

packageJ = reg.packageJ

help =
  c.black "[  docs] #{packageJ.homepage}"

# -------------------------------------------------------------------------------------------------------

lit = R.pipe do
  R.zipWith (x,f) ->
    switch R.type f
    | \Function => f x
    | otherwise => x
  R.join ""

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

  if (state.vr.length is 0)

    inner = ""

  else

    inner = "|" + state.vr.join "|"

  str = R.join "",["[#{name}",inner,"]"]

  (c.warn str) + " []"

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

rm-paths = R.find (x) -> (x in [\hoplon,\node_modules])

show_stack = ->

  l help + "\n"

  E = esp.parse new Error!

  for I in E

    {lineNumber,fileName,functionName,columnNumber} = I

    path = fileName.split "/"

    [first,second] = path

    if (rm-paths path) then continue

    if ((first is \internal) and (second is \modules)) then continue

    if (functionName is \Object.<anonymous>)

      functionName = ""

    l lit do
      [
        "  - "
        R.last path
        ":"
        lineNumber
        " "
        functionName
        "\n    "
        fileName + ":"
        lineNumber
        ":" + columnNumber + "\n"
      ]
      [0,c.warn,0,c.er,0,0,0,c.black,c.er,c.black]

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
  | \ma                        => \ma
  | \ar,\arn                   => \ar
  | \wh,\whn                   => \wh
  | \arwh,\arwhn,\arnwhn,\arma => \arwh

StrArgLen = (fname,ctype,eType)->

  data = switch ctype
  | \ma   => [1,'function|[fun....]']
  | \wh   => [2,'(function,function|any)']
  | \ar   => [2,'(number|[num...],function|any)']
  | \arwh => [3,'(number|[num...],function,function|any)']

  switch eType
  | \many_args =>
    [
      "too many arguments"
      c.er "  only #{data[0]} arguments \n\n  accepted type :: #{data[1]} "
    ]
  | \few_args  =>
    [
      "too few arguments"
      c.er "  requires #{data[0]} arguments \n\n  type : #{data[1]} "
    ]

StrEType = (fname,eType) ->

  ctype = map_fname_to_ctypes fname

  switch eType
  | \many_args,\few_args => return StrArgLen fname,ctype,eType

  init = switch ctype
  | \ma => c.er 'function|[fun....]'

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


  init = lit ["(",init,")"],[c.ok,null,c.ok]

  [init,'One of the argument cannot be used by the function']


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

  show_stack!

print.state_undef = (type) ->

  l lit do
    ["[#{name}][Error]"]
    [c.err]

  l lit do
    [("\n  ." + type)]
    [c.warn]

  l lit do
    ["\n  Javascript does not allow referencing of .prototype function.\n"]
    [c.black]


  show_stack!

print.route = ([Er,data]) !->

  [ECLASS,whichE,info] = Er

  switch ECLASS
  | \input       =>

    [ __, fname , arg_placement ] = Er

    print.typeError do
      data
      fname
      arg_placement

  | \not_array   => print.not_array data

  | \setting     => print.setting Er[1],data

  | \state_undef => print.state_undef data

  | otherwise    => l Er,data