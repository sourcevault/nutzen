reg = require "./registry"

{com,print,sig} = reg

{l,z,R,j,hop,flat,pad,alpha_sort,esp,c,lit,create_stack} = com

pkgname = reg.pkgname

help =
  c.grey "[  docs] #{reg.homepage}\n"

# -------------------------------------------------------------------------------------------------------

show_stack = create_stack 2,[],help

# -  - - - - - - - - - - - - - - - - - - - - - - - - --  - - - - - - - - - - - - - - - - - - - - - - - - -

print.resreq = ([cat,type]) ->

  methodname = switch cat
  | \resreq  => ".resreq"
  | \res     => ".restricted"
  | \req     => ".required"

  l lit ["[#{pkgname}]","[argumentError] ",methodname],[c.er2,c.er3,c.er1]

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
  | \and,\or  => fi.andor data

show_chain = ([init,last]) ->

  l lit do
    ["  ",((init).join "."),("."  + last),"(xx)"," <-- error here"]
    [0,c.ok,c.er2,c.er3,c.er2]

show_name = (name,type = "[inputError] ") ->

  l lit do
    ["[#{pkgname}]",type,name]
    [c.er1,c.er3,c.warn]

print.input_fault.andor = ([type,info])->

  show_name ".#{info[1]}"

  l ""

  show_chain info

  l ""

  switch type
  | \arg_count =>

    l c.grey do
      "  no value passed."
      "\n\n"
      " minimum of 1 argument of function type is needed."


  | \not_function =>

    l c.er1 "  one of the argument is not a function."

  l ""

  l c.ok " accepted type signature :"

  l ""

  l c.blue " - :: fun|[fun,..],..,.."

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

    l c.er1 "  first argument has to be a function / valleydate object ."

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

on_dtype = {}
  ..string = "string|number , function"
  ..array  = "string|[number....] , function"
  ..object = "object{*:function} "


print.input_fault.on = ([patt,loc])->

  eType = switch patt
  | \typeError => \typeError
  | otherwise  => \inputError

  show_name ".on","[#{eType}] "

  l ""

  show_chain loc

  l ""

  switch patt
  | \typeError,\arg_count =>

    switch patt
    | \typeError =>

      l c.er1 "  unable to pattern match on user input."

    | \arg_count =>

      l c.er1 "  minimum of 2 arguments required."

    l ""

    l c.grey " types that may match :"

    l ""


    lines = [c.blue (" - .on :: #{val}") for key,val of on_dtype].join "\n\n"

    l lines


  | otherwise  =>

    dtype = on_dtype[patt]

    l lit do
      [" .on"," :: ",dtype," <-- what may match"]
      [c.warn,c.white,c.ok,c.grey]

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

print.log = ->

  prop = getprop @

  lit ["{.*} ",prop.join " "],[c.pink,c.blue]

sort = (x) -> x.sort(alpha_sort.ascending)

same = includes ['and', 'or', 'cont', 'jam', 'fix', 'err','map','on','alt','auth','edit']

myflat = hop
.wh do
  (ob) ->
    switch (R.type ob)
    | \Function,\Object => true
    | otherwise         => false

  (ob,fin = {}) ->

    keys = Object.keys ob

    for I in keys

      if not (same I)

        prop = myflat ob[I]

        fin[I] = prop

    fin

.def -> {}

split = R.groupBy (name) -> (/\./).test name

find_len = R.reduce (accum,x) ->

  if x.length > accum

    x.length

  else accum

print.inner = ->

  props =  sort [ I for I of flat myflat @]

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

  str = c.pink "{.*}\n"

  str += c.blue table

  str

module.exports = print