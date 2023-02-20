ext = require \../utils/main

print = {}

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

export {...ext,print:print}

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -

com = ext.com

{z,j,l,R,c,esp,create_stack,lit,version} = com

print.log  = {}

help         = c.grey "[  docs] #{com.homepage}"

show_stack   = create_stack 2,['internal/modules/cjs','node:internal'],(help + '\n')

object_name  = \hoplon.guard

pkgname      = "#{object_name}\#v#{version}"

print.log.def_fault = -> c.er2 "[error.#{pkgname}]"

print.log.proto = ->

  state = @self

  if state is undefined

    return (c.pink "[#{pkgname}]") + (c.er2 "[state is undefined]")

  print.log.main state

print.log.wrap = (state) -> -> print.log.main state

print.log.prox = (state) ->

  # [hoplon.guard#v2.0.0|debug|unary] []
  # [hoplon.guard#v2.0.0|debug] []
  # [hoplon.guard#v2.0.0] []

  if state is null
    return c.er2 "[error.#{pkgname}]"

  if state.lock
    return c.ok "[Function]"

  if (state.sorted_path.length is 0)

    inner = ""

  else

    inner = "/" + state.sorted_path.join "."

  str = R.join "",["[#{pkgname}",inner,"]"]

  (c.pink str) + " []"

# [hoplon.guard] [ ar(2) ]

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

  put = c.pink ("[#{object_name}" + str + "]")

  if state.debug
    if state.str.length

      arr = arrange state.str
      arr_str = " [ " + arr + " ]"

    else

      arr_str = " []"

  else

    arr_str = ""


  str = put + arr_str

  str

# -  - - - - - - - - - - - - - - - - - - - - - - - - --  - - - - - - - - - - - - - - - - - - - - - - - - -

show_chain = (input-str,path = [],show-args = true)->

  str = ""

  for I in input-str

    str += ".#{I}(~)"

  str = c.ok str

  if show-args

    str += [ c.warn ".#{I}" for I in path].join ""

    str += lit ["(xx)"," <--"," type error in argument"],[c.er3,c.er3,c.er3]

  else

    str += c.er2 ([".#{I}" for I in path].join "")

    str += c.er3 " <-- error here."

  str

map_fname_to_ctypes = (fname)->

  switch fname
  | \ar,\arn                          => \ar
  | \wh,\whn                          => \wh
  | \arwh,\arnwh,\arwhn,\arnwhn       => \arwh
  | otherwise                         => fname

txt = {}

arcap_txt = 
  *c.er2 ".arcap only accepts 1,2,3 or 4 arguments :\n"
   c.ok " arcap/1 :: object"
   c.ok " arcap/2 :: PI,F"
   c.ok " arcap/3 :: PI,FT,F"
   c.ok " arcap/4 :: PI,FT,F,FA"

txt.arcap = arcap_txt.join "\n"

cap_txt = 
  *c.er2 ".cap only accepts 2 or 3 arguments :\n"
   c.ok " cap/2 :: FT,FA"
   c.ok " cap/3 :: FT,F,FA"

txt.cap = cap_txt.join "\n"

StrArgLen = (fname,ctype,eType,extra)->

  switch ctype + "." + eType
  | \cap.few_args    =>
    return
     *c.er3 " too few arguments"
      txt.cap
  | \cap.many_args   =>
    return
     *c.er3 " too many arguments"
      txt.cap
  | \arcap.many_args =>
    return
     *c.er3 " too many arguments"
      txt.arcap
  | \arcap.few_args  =>
    return
     *c.er3 " too few arguments"
      txt.arcap

  data = switch ctype
  | \wh    => [2,'FT,FA']
  | \ar    => [2,'(pos_int|[pos_int,...]),FA']
  | \arwh  => [3,'(pos_int|[pos_int,...]),FT,FA']

  switch eType
  | \many_args =>
    [
      c.er3 "too many arguments"
      lit do
        ["expects #{data[0]} arguments ","\n\n #{fname}"," :: #{data[1]} "]
        [c.er2,c.ok,c.ok]
    ]
  | \few_args  =>
    [
      c.er3 "too few arguments"
      lit do
        ["expects #{data[0]} arguments ","\n\n #{fname}"," :: #{data[1]} "]
        [c.er2,c.ok,c.ok]
    ]

defc = c.er1 'one of the argument is of the wrong type.'

StrEType = (fname,data) ->

  [eType,extra] = data

  ctype = map_fname_to_ctypes fname

  switch eType
  | \many_args,\few_args => return StrArgLen fname,ctype,eType,extra

  switch ctype

  | \ar =>

    init = switch eType
    | \first =>

      lit ["(","pos_int","|[pos_int,...]),FA"],[c.ok,c.er3,c.ok]

    | \array =>

      lit ["(pos_int|","[pos_int,..]","),FA"],[c.ok,c.er3,c.ok]

    | \ob_not_object =>

      lit ["(","object",")|(PI,FA)"],[c.ok,c.er3,c.ok]

  | \wh =>

    init = switch eType
    | \first =>

      lit ["FT",",FA"],[c.er3,c.ok]

  | \arwh =>

    init = switch eType
    | \first =>

      lit ["PI",",FT,FA"],[c.er3,c.ok]

    | \pos_int =>

      lit ["(","pos_int","|[pos_int,..]),FT,FA"],[c.ok,c.er3,c.ok]

    | \array =>

      lit ["(pos_int|","[pos_int,..]","),FT,FA"],[c.ok,c.er3,c.ok]

    | \second =>

      lit ["(pos_int|[pos_int,..]),","FT",",FA"],[c.ok,c.er3,c.ok]

    | \ob_not_object =>

      lit ["(","object",")|((pos_int|[pos_int,..]),FT,FA)"],[c.ok,c.er3,c.ok]

    | \ob.inner_not_array =>

      lit do
        [  "object(","#{extra.join ":"}:[..xx..]",")"]
        [      c.er1,          c.er3,c.er1]

    | \ob.key_value_not_array =>

      lit ["object(","#{extra}:xx",")"],[c.er1,c.er3,c.er1]

    | \ob.inner_array_validator =>

      lit do
        ["object(","#{extra.join ":"}:", "",  "(FT",",FA",  ")",  ")"]
        [    c.er1,              c.er3,c.er1, c.er3, c.ok,c.er3,c.er1]

    | \ob.few_args =>

      str = ["object" "(",(extra.join ":"),")"]

      col = [c.er2,c.er2,c.er3,c.er2]

      inner = lit str,col

      lit do
        ["arwh/1 :: ",inner]
        [c.ok,null]

    | \ob.many_args =>

      str = ["object" "(",(extra.join ":"),")"]
      col = [c.er2,c.er2,c.er3,c.er2]

      inner = lit str,col

      lit do
        ["arwh/1 :: ",inner]
        [c.ok,null]

    comment = switch eType
    | \ob.few_args  => c.er1 "minimum of 1 value needed."
    | \ob.many_args => c.er1 "only accepts 1 or 2 value(s)."
    | otherwise   => defc

  | \arcap =>

    init = switch eType
    | \num =>

      switch extra
      | 4 =>
        lit do
          ["arcap/4 :: (","pos_int","|[pos_int,..]),FT,F,FA"]
          [c.ok,c.er3,c.ok]
      | 3 =>
        lit do
          ["arcap/3 :: (","pos_int","|[pos_int,..]),FT,FA"]
          [c.ok,c.er3,c.ok]

    | \num_array =>

      switch extra
      | 4 =>
        lit do
          ["arcap/4 :: ","(pos_int|","[pos_int,..]","),FT,F,FA"]
          [c.ok,c.ok,c.er3,c.ok]
      | 3 =>
        lit do
          ["arcap/3 :: ","(pos_int|","[pos_int,..]","),FT,FA"]
          [c.ok,c.ok,c.er3,c.ok]

    | \validator =>

      switch extra
      | 4 =>
        lit do
          ["arcap/4 :: PI,","FT",",F,FA"]
          [c.ok,c.er3,c.ok]

      | 3 =>
        lit do
          ["arcap/3 :: PI,","FT",",FA"]
          [c.ok,c.er3,c.ok]

    | \lastview =>

      lit do
        ["arcap/4 :: PI,FT,","F",",FA"]
        [c.ok,c.er3,c.ok]

    | \ob_not_object =>

      lit do
        ["arcap/1 :: (","object",")"]
        [c.ok,c.er3,c.ok]

    | \ob.few_args =>


      str = ["object" "(",extra[0] + ":" + extra[1],")"]
      col = [c.er2,c.er2,c.er3,c.er2]

      inner = lit str,col

      lit do
        ["arcap/1 :: ",inner]
        [c.ok,null]

    | \ob.many_args =>

      str = ["object" "(",extra[0] + ":" + extra[1],")"]
      col = [c.er2,c.er2,c.er3,c.er2]

      inner = lit str,col

      lit do
        ["arcap/1 :: ",inner]
        [c.ok,null]

    | \ob.key_value_not_array =>

      lit do
        ["arcap/1 :: (",  "object(", "#{extra}:xx",  ")",")"]
        [         c.ok,      c.er1,      c.er3,c.er1,c.ok]

    | \ob.inner_not_array =>

      lit do
        ["arcap/1 :: ","object(","#{extra.join ":"}:[..xx..]",  ")"]
        [        c.ok,   c.er1,           c.er3,c.er1]

    | \ob.inner_array_validator =>

      [cat,index] = extra

      switch cat
      | 2 =>

        str = [(c.er3 "FT"),(c.ok ",FA")].join ""

        lit do
          ["object(","#{index.join ":"}:","[",str,"])"]
          [ c.er1,c.er3,c.er1,null,c.er1]

      | 3 => 

        str = [(c.er3 "FT"),(c.ok ",F,FA")].join ""

        lit do
          ["object(","#{index.join ":"}:","[",str,"])"]
          [ c.er1,c.er3,c.er1,null,c.er1]

    | \ob.inner_lastview =>

      lit do
        ["object(","#{extra.join ":"}:",   "[",    "FT,",   "F",",FA",    "]",")"]
        [    c.er1,               c.er3, c.er2,     c.ok, c.er3,c.ok,    c.er2,c.er1]


    comment = switch eType
    | \ob.few_args  => c.er1 "minimum 1 argument needed."
    | \ob.many_args => c.er1 "only accepts 1, 2 and 3 arguments."
    | otherwise     => defc
      

  | \cap =>

    init = switch eType

    | \validator =>

      si = switch extra
      | 2 => ",FA"
      | 3 => ",F,FA"

      str = "cap/#{extra} :: "

      lit do
        [str,  "FT",si]
        [c.ok,c.er3,c.ok]

    | \lastview =>

      lit do
        ["cap/3 :: FT,","F",",FA"]
        [c.ok,c.er3,c.ok]

    comment = defc


  switch fname
  | \arcap,\cap,\arwh =>

    [init,comment]

  | otherwise =>

    init = lit [fname + " :: ",init],[c.ok,0]

    [init,defc]


print.typeError = (ta) ->

  [E,fname,attribute,data] = ta

  [type_signature,comment] = StrEType fname,attribute

  legend = 
      *" F = function"
       " PI =  pos_int|[pos_int,...]"
       " FA = function|any"
       " FT = function|hoplon.types"

  legend = [c.grey I for I in legend].join "\n"

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
    c.er1 ([ ".#{I}(~)" for I in data.str].join "")
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


print.docstring = """
  #{c.pink pkgname}
  #{c.grey help}
  """