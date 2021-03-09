com = require "../../dist/utils/main.js"

print = {}

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

export
  com             = com
  print           = print
  modflag         = Symbol "self"

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

{z,l,R,c,esp,create_stack,lit} = com

print.log  = {}

help       = c.grey "[  docs] #{com.homepage}\n"

show_stack = create_stack 3,[],help

pkgname     = \hoplon.guard

print.log.def_fault = -> c.er2 "[error.#{pkgname}]"

print.log.proto = ->

  state = @[modflag]

  if state is undefined

    return (c.er1 "[#{pkgname}]") + (c.er2 "[state undefined]")

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

  str = R.join "",["[#{pkgname}",inner,"]"]

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
      return c.er2 "[#{pkgname}|error]"

  str = ""

  if state.immutable
    str += "|immutable"
    clr = c.ok
  else
    str += "|mutable"
    clr = c.warn

  if state.apply
    str += "|apply"

  put = clr ("[#{pkgname}" + str + "]")

  arr = arrange state.str

  str = put + " " + "[ " + arr + " ]"

  str

# -  - - - - - - - - - - - - - - - - - - - - - - - - --  - - - - - - - - - - - - - - - - - - - - - - - - -


show_chain = (input-str,path = [],show-args = true)->

  str = ""

  for I in input-str

    str += ".#{I}(~)"

  str = c.ok str

  if show-args

    str += [ c.warn ".#{I}" for I in path].join ""

    str += lit ["(xx)"," <-- error within argument"],[c.er3,c.er1]

  else

    str += c.er2 ([".#{I}" for I in path].join "")

    str += c.er1 " <-- error here."

  str


map_fname_to_ctypes = (fname)->

  switch fname
  | \ma                        => \ma
  | \ar,\arn                   => \ar
  | \wh,\whn                   => \wh
  | \arwh,\arwhn,\arnwhn,\arma => \arwh
  | \arpar                     => \arpar


StrArgLen = (fname,ctype,eType)->

  data = switch ctype
  | \ma    => [1,'(function|[fun....])']
  | \wh    => [2,'(function,function|any)']
  | \ar    => [2,'(number|[num...],function|any)']
  | \arwh  => [3,'(number|[num...],function,function|any)']
  | \arpar => [4,'(number|[num...],function,function|any,function)']

  switch eType
  | \many_args =>
    [
      c.pink "too many arguments"
      lit do
        ["only #{data[0]} arguments ","\n\n #{fname}"," :: #{data[1]} "]
        [c.blue,c.ok,c.ok]
    ]
  | \few_args  =>
    [
      c.pink "too few arguments"
      lit do
        ["requires #{data[0]} arguments ","\n\n #{fname}"," :: #{data[1]} "]
        [c.blue,c.ok,c.ok]
    ]

StrEType = (fname,eType) ->

  ctype = map_fname_to_ctypes fname

  switch eType
  | \many_args,\few_args => return StrArgLen fname,ctype,eType

  init = switch ctype
  | \ma => lit ["function|[fun....],function|any"],[c.er2,c.ok]

  | \arma =>

    switch eType

    | \first =>

      lit ["number" "|[num...],[fun....]"],[c.er2,c.ok]

    | \array =>

      lit ["number" "|[num..]" ",[fun....]"],[c.ok,c.er2,c.ok]

    | \not_function =>

      lit ["number|[num..]",",[fun....]"],[c.ok,c.er2]

  | \ar =>

    switch eType
    | \first =>

      lit ["number" "|[num...],function|any"],[c.er2,c.ok]

    | \array =>

      lit ["number" "|[num..]" ",function|any"],[c.ok,c.er2,c.ok]

  | \wh =>
    switch eType
    | \first =>

      lit ["function",",function|any"],[c.er2,c.ok]

    | \second =>

      lit ["function","function|any"],[c.ok,c.er2]

  | \arwh =>

    switch eType
    | \num =>

      lit ["number","|[num..],function,function|any"],[c.er2,c.ok]

    | \array =>

      lit ["number|","[num..]" ",function,function|any"],[c.ok,c.er2,c.ok]

    | \second =>

      lit ["number[num..],","function",",function|any"],[c.ok,c.er2,c.ok]

  | \arpar =>

    switch eType
    | \num =>

      lit ["number" "|[num..],function,function|any,function"],[c.er2,c.ok]

    | \array =>

      lit do
        ["number|","[num..]",",function,function|any,function"]
        [c.ok,c.er2,c.ok]

    | \second =>

      lit do
        ["number[num..],","function",",function|any,function"]
        [c.ok,c.er2,c.ok]

    | \fourth =>

      lit do
        ["number[num..],function,function|any,","function"]
        [c.ok,c.er2]


  init = lit ["(",init,")"],[c.ok,0,c.ok]

  [init,(c.pink 'One of the argument is of the wrong type.')]


print.typeError = (data) ->

  [E,fname,attribute,data] = data

  [type_signature,comment] = StrEType fname,attribute

  l lit do
    ["[#{packageJ.name}]","[typeError]"," .#{fname}(","...",")"]
    [c.er1,c.er2,c.grey,c.er3,c.grey]

  l do
    '\n'
    (show_chain data.str,[fname])
    '\n\n'
    type_signature
    '\n\n'
    comment
    '\n'

  show_stack E

print.unary_not_array = ([E,data]) ->

  l lit do
    ["[#{packageJ.name}]","[typeError]"]
    [c.er1,c.er2]


  l do
    '\n'
    lit do
      [\unary,(show_chain [...data.str,\def],[])]
      [c.warn,0]
    '\n'

  l lit do
    [" unary namespace requires first argument to be array like.","\n"]
    [c.pink,0]

  show_stack E

print.setting = ([E,type,vr,key]) ->

  msg = switch type
  | \path_locked     => "all settings enabled."
  | \already_in_path => "setting already enabled."
  | \not_in_opts     => "undefined option."

  l lit ["[#{pkgname}][configError]"," #{msg}"],[c.er2,c.warn]

  l do
    '\n'
    lit [(vr.join "."),".",key],[c.ok,c.ok,c.er]
    '\n'

  show_stack E

print.state_undef = ([E,fname]) ->

  l lit do
    ["[#{pkgname}][Error]"]
    [c.er2]

  l lit do
    [("\n  ." + fname)]
    [c.warn]

  l lit do
    ["\n  Javascript does not allow referencing of .prototype function.\n"]
    [c.pink]

  show_stack E

print.arpar_not_array = ([E,data]) ->

  [type_signature] = StrEType 'arpar',"second"

  l lit do
    ["[#{packageJ.name}]","[typeError]"," .arpar(","...",")"]
    [c.er1,c.er2,c.grey,c.er3,c.grey]

  l do
    '\n'
    show_chain data.str,[\arpar]
    '\n\n'
    type_signature
    '\n\n'
    c.pink ".arpar validator function requires return value to be array like."
    '\n'

  show_stack E

print.route = ([ECLASS,data]) !->


  switch ECLASS
  | \input             => print.typeError data

  | \unary_not_array   => print.unary_not_array data

  | \setting           => print.setting data

  | \arpar_not_array   => print.arpar_not_array data

  | \state_undef       => print.state_undef data

  | otherwise          => l "print.route\n\n",Er,data
