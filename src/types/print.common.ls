com = require \../utils/main

xop = require \../guard/main

print      = {}

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - - -  - -- -  - -

{l,z,R,j,flat,pad,alpha_sort,esp,c,lit,create_stack,version} = com

pkgversion = version

pkgname    = \hoplon.types

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - - -  - -- -  - -

export
  com             = com
  print           = print
  pkgname         = pkgname

# -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -----------------

print.log  = {}

help       = c.grey "[  docs] #{com.homepage}\n"

# -------------------------------------------------------------------

show_stack = create_stack 1,['internal/modules/cjs','node:internal'],help

# -  - - - - - - - - - - - - - - - - - - - - - - - - --  - - - - - -

type_color = c.ok

print.resreq = ([cat,type]) ->

  methodname = switch cat
  | \resreq  => ".resreq"
  | \res     => ".restricted"
  | \req     => ".required"

  show_name methodname,"[argumentError] "

  txt = switch cat
  | \resreq =>

    switch type
    | \prime => "  .resreq only accepts 2 argument of type Array of String / Number."
    | \res   => "  first argmuent is not a Array of String / Number."
    | \req   => "  second argmuent is not a Array of String / Number."

  | \res,\req    => "  one of the (inner) argument is not of type of String / Number."


  l lit ['\n',txt,'\n'],[0,c.warn,0]

print.input_fault = ([method_name,data]) ->

  fi = @input_fault

  switch method_name
  | \on       => fi.on data
  | \map      => fi.map data
  | \custom   => fi.custom data
  | \and,\or  => fi.andor data,method_name
  | \catch    => fi.catch data


show_chain = (data) ->

  [chain_data,last] = data

  flattened_chain = (chain_data.flat Infinity).reverse!

  middle = R.tail flattened_chain

  if middle.length

    start_chain = middle
    |> R.map (each) -> ".#{each}(..)"
    |> R.splitEvery 2
    |> (bulk) -> (bulk[0].unshift flattened_chain[0]);bulk
    |> R.map (line) -> (line.unshift ' '); line
    |> R.tap (x) ->
    |> R.map R.join ""
    |> R.join "\n"

  else

    start_chain = ' ' + flattened_chain[0]


  l lit do
    [start_chain,("."  + last),"(xx)"," <-- error here"]
    [c.grey,c.warn,c.er3,c.er3]

show_name = (extra,type = "[inputError] ") ->

  l lit do
    ["[#{pkgname}:v#{pkgversion}]", type,extra]
    [                       c.er2, c.er2,c.er2]

print.input_fault.andor = ([type,info],method_name)->

  show_name ".#{info[1]}"

  l ""

  show_chain info

  l ""

  txt = switch type
  | \arg_count    => " minimum of 1 argument of function type is needed."

  | \not_function => " one of the argument is not a function."

  l c.er3 txt

  l ""

  l c.grey " expected type signature :"

  l ""

  l type_color " #{method_name} :: fun,..,.."

  l ""


print.input_fault.custom = ([patt,loc]) ->

  show_name "custom validator"

  l ""

  switch patt
  | \arg_count =>

    l c.grey do
      "  no value passed."
      "\n\n"
      " minimum of 1 argument of function type is needed."

  | \not_function =>

    l c.er1 "  first argument has to be a function / hoplon.types object ."

  l ""

print.input_fault.map = ([patt,loc]) ->

  show_name ".map"

  l ""

  show_chain loc

  l ""

  switch patt
  | \arg_count    =>

    l c.grey "  only accepts 1 argument required of function type."

  | \not_function =>

    l c.grey "  first argument has to be a function."


  l ""


print.input_fault.catch = ([patt,info]) ->

  show_name ".catch"

  l ""

  switch patt
  | \arg_count,\not_function =>

    l c.pink " only accepts 1 argument of type function."

  l ""

  show_chain info

  l ""

  l c.grey " expected type signature :"

  l ""

  l type_color " catch :: (function|void)"

  l ""

on_dtype = {}
  ..string       = "(string|number),function"
  ..array        = "[(string|number),..],function"
  ..object       = "object{*:function}"

print.input_fault.on = ([patt,loc])->

  eType = switch patt
  | \typeError => \typeError
  | otherwise  => \inputError

  show_name ".#{loc[1]}","[#{eType}] "

  l ""

  show_chain loc

  l ""

  switch patt
  | \typeError,\arg_count =>

    switch patt
    | \typeError =>

      l c.er3 "  unable to pattern match on user input."

    | \arg_count =>

      l c.er3 "  only accepts 1 or 2 arguments."

    l ""

    l c.grey " types that may match :"

    l ""

    lines = [type_color (" - ." + loc[1] + " :: #{val}") for key,val of on_dtype].join "\n\n"

    l lines


  | otherwise  =>

    dtype = on_dtype[patt]

    l lit do
      [" .#{loc[1]}", " :: ",dtype," <-- expected signature."]
      [  c.ok,   c.ok,        c.ok,                      c.ok]

  l ""


print.route = ([E,ECLASS,info]) ->

  switch ECLASS
  | \resreq       => print.resreq info
  | \input.fault  => print.input_fault info

  show_stack E

# ------------------------------------------------------------------------

getprop = (item) ->

  fin = []

  for I of item
    fin.push I

  fin

includes = R.flip R.includes

sort = (x) -> x.sort alpha_sort.ascending

print.log = (name) -> ->

  switch name
  | \functor      =>
    str = ':*m'
  | \normal       =>
    str = ''
  | \core.functor =>
    str = ':*m:try'
  | \core.normal  =>
    str = ':try'

  # prop = sort (getprop @)

  # lit ["{.*} ",prop.join " "],[c.warn,c.grey]

  lit [pkgname,str],[c.ok,c.pink]


same = includes ['and', 'or', 'cont', 'jam', 'fix', 'err','map','on','alt','auth','edit','tap','forEach','wrap']

# myflat = xop
# .wh do
#   (ob) ->
#     switch (R.type ob)
#     | \Function,\Object => true
#     | otherwise         => false

#   (ob,fin = {}) ->

#     keys = Object.keys ob

#     for I in keys

#       if not (same I)

#         prop = myflat ob[I]

#         fin[I] = prop

#     fin

# .def -> {}

split = R.groupBy (name) -> (/\./).test name

find_len = R.reduce (accum,x) ->

  if x.length > accum

    x.length

  else accum

print.inner = ->

  # props =  sort [ I for I of flat myflat @]

  props.push \tap

  ob = split props

  len = (find_len 0,props) + 4

  if (ob.true is undefined) and (ob.false is undefined)
    init-table = []
  else if ob.true
    init-table = [...ob.true,...ob.false]
  else
    init-table = ob.false

  table = [pad.padRight I, len for I in init-table]

  table = [I.join " " for I in (R.splitEvery 2,table)].join "\n"

  str = c.warn "{.*} v#{version}\n"

  str += table

  str