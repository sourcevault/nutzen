com = require "../../dist/utils/main.js"

print = {}

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

export
  com             = com
  print           = print
  modflag         = Symbol "self"
  defacto         = Symbol "default"

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

{z,zj,j,l,R,c,esp,create_stack,lit,version} = com

print.log  = {}

help       = c.grey "[  docs] #{com.homepage}\n"

show_stack = create_stack 1,['internal/modules/cjs','node:internal'],help

object_name  = "hoplon.guard"

pkgname      = "#{object_name}\#v#{version}}"

print.log.def_fault = -> c.er2 "[error.#{pkgname}]"

print.log.proto = ->

  state = @[modflag]

  if state is undefined

    return (c.pink "[#{pkgname}]") + (c.er2 "[state undefined]")

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
      return c.pink "[#{object_name}|error]"

  str = ""

  if state.immutable
    str += "|immutable"
    clr = c.ok
  else
    str += "|mutable"
    clr = c.warn

  if state.apply
    str += "| apply"

  put = clr ("[#{object_name}" + str + "]")

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

    str += lit ["(xx)"," <-- type error in argument"],[c.er3,c.er1]

  else

    str += c.er2 ([".#{I}" for I in path].join "")

    str += c.er1 " <-- error here."

  str

map_fname_to_ctypes = (fname)->

  switch fname
  | \ar,\arn                   => \ar
  | \wh,\whn,\ma               => \wh
  | \arwh,\arwhn,\arnwhn,\arma => \arwh
  | otherwise                  => fname

StrArgLen = (fname,ctype,eType)->

  data = switch ctype
  | \wh    => [2,'FT,FA']
  | \ar    => [2,'(number|[num...]),FA']
  | \arwh  => [3,'(number|[num...]),FT,FA']
  | \par   => [3,'FT,FA,FT']
  | \arpar => [4,'(number|[num...]),FT,FA,F']

  switch eType
  | \many_args =>
    [
      c.er3 "too many arguments"
      lit do
        ["only #{data[0]} arguments ","\n\n #{fname}"," :: (#{data[1]}) "]
        [c.blue,c.ok,c.ok]
    ]
  | \few_args  =>
    [
      c.er3 "too few arguments"
      lit do
        ["requires #{data[0]} arguments ","\n\n #{fname}"," :: (#{data[1]}) "]
        [c.blue,c.ok,c.ok]
    ]

StrEType = (fname,data) ->

  [eType,extra] = data

  ctype = map_fname_to_ctypes fname

  switch eType
  | \many_args,\few_args => return StrArgLen fname,ctype,eType

  init = switch ctype

  | \ar =>

    switch eType
    | \first =>

      lit ["(","number","|[num...]),FA"],[c.ok,c.er2,c.ok]

    | \array =>

      lit ["(number","|[num..]","),FA"],[c.ok,c.er2,c.ok]

    | \ob_not_object =>

      lit ["(","object",")|((number|[num..]),FA)"],[c.ok,c.er2,c.ok]

  | \wh =>

    switch eType
    | \first =>

      lit ["FT",",FA"],[c.er2,c.ok]

    | \second =>

      lit ["FT","FA"],[c.ok,c.er2]

  | \arwh =>

    switch eType
    | \num =>

      lit ["(","number","|[num..]),FT,FA"],[c.ok,c.er2,c.ok]

    | \array =>

      lit ["(number|","[num..]","),FT,FA"],[c.ok,c.er2,c.ok]

    | \second =>

      lit ["(number|[num..]),","FT",",FA"],[c.ok,c.er2,c.ok]

    | \ob_not_object =>

      lit ["(","object",")|((number|[num..]),FT,FA)"],[c.ok,c.er2,c.ok]

    | \ob_inner_array =>

      lit ["(object(","#{extra}:...","))"],[c.ok,c.er2,c.ok]

    | \ob_inner_array_validator =>

      lit ["(object(","#{extra}:","(","FT",",FA)))"],[c.ok,c.er2,c.ok,c.er2,c.ok]

    | \ob_inner_not_array =>

      lit do
        ["(object(","#{extra}:[..]","))"]
        [      c.ok,          c.er2,c.ok]


  | \arpar =>

    switch eType
    | \num =>

      lit do
        ["(","number","|[num..]),FT,FA,F"]
        [c.ok,c.er2,c.ok]

    | \num_array =>

      lit do
        ["(number|","[num..]","),FT,FA,F"]
        [c.ok,c.er2,c.ok]

    | \validator =>

      lit do
        ["(number|[num..]),","FT",",FA,F"]
        [c.ok,c.er2,c.ok]

    | \lastview =>

      lit do
        ["(number|[num..]),F,FA,","F"]
        [c.ok,c.er2]

    | \ob_not_object =>

      lit ["(","object",")|((number|[num..]),FT,FA,F)"],[c.ok,c.er2,c.ok]

    | \ob_inner_not_array =>

      lit do
        ["(object(","#{extra}:[..]","))"]
        [      c.ok,          c.er2,c.ok]

    | \ob_inner_array =>

      lit do
        ["(object(","#{extra}","))"]
        [      c.ok,     c.er2,c.ok]

    | \ob_inner_array_validator =>

      lit do
        ["(object(","#{extra}:",  "(", "FT",",FA,F)))"]
        [      c.ok,      c.er2, c.ok,c.er2,      c.ok]

    | \ob_inner_lastview =>

      lit do
        ["(object(","#{extra}:","(FT,FA,",  "F",")))"]
        [      c.ok,      c.er2,     c.ok,c.er2,c.ok]

  | \par =>

    switch eType

    | \validator =>

      lit do
        ["FT",",FA,F"]
        [c.er2,c.ok]

    | \lastview =>

      lit do
        ["FT,FA",",F"]
        [c.ok,c.er2]

  init = lit [fname + " :: ",init],[c.grey,0]

  [init,(c.pink 'one of the argument is of the wrong type.')]


print.typeError = (ta) ->

  [E,fname,attribute,data] = ta

  [type_signature,comment] = StrEType fname,attribute

  legend = 
      *"  F = function"
       "  FA = function|any"
       "  FT = function|hoplon.types"

  legend = [c.blue I for I in legend].join "\n"

  l lit do
    ["[#{pkgname}]","[typeError]"," .#{fname}(...)"]
    [c.pink,c.er2,c.er2]


  l do
    '\n'
    (show_chain data.str,[fname])
    '\n\n'
    legend
    '\n\n'
    type_signature
    '\n\n'
    comment
    '\n'

  show_stack E

print.unary_not_array = ([E,data]) ->

  l lit do
    ["[#{pkgname}]","[typeError]"]
    [c.pink,c.er2]

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
  | \not_in_opts     => "option not defined."

  l lit do
    ["[#{pkgname}]","[configError]"," #{msg}"]
    [c.pink,c.er2,c.er1]

  l do
    '\n'
    lit [(vr.join "."),"."+key],[c.ok,c.er3]
    '\n'

  show_stack E

print.state_undef = ([E,fname]) ->

  l lit do
    ["[#{pkgname}]","[Error]"]
    [c.pink,c.er1]

  l lit do
    [("\n  ." + fname)]
    [c.warn]

  l lit do
    ["\n  Javascript does not allow referencing of .prototype function.\n"]
    [c.pink]

  show_stack E

print.validator_return_not_array = (ta) ->

  [E,[type,loc],data] = ta

  [type_signature] = StrEType type,loc

  l lit do
    ["[#{pkgname}]","[typeError]"," .#{type}(","...",")"]
    [c.pink,c.er2,c.er2,c.er3,c.er2]

  l do
    '\n'
    show_chain (R.init data.str),[type]
    '\n\n'
    type_signature
    '\n\n'
    c.pink "validator function requires return value to be array like."
    '\n'

  show_stack E

print.route = (ta) !->

  [ECLASS,data] = ta

  switch ECLASS
  | \input                      => print.typeError data

  | \unary_not_array            => print.unary_not_array data

  | \setting                    => print.setting data

  | \validator_return_not_array => print.validator_return_not_array data

  | \state_undef                => print.state_undef data

  | otherwise                   => l "print.route\n\n",Er,data
