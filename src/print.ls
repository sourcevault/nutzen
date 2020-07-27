{l,z,chalk,R,j,pretty-error} = require "./common"

reg = require "./registry"

printE = reg.printE

pJ = reg.packageJ

c = {}
  ..ok    = chalk.green.bold
  ..er    = chalk.hex "FF0000"
  ..warn  = chalk.hex "FFFFCD"
  ..black = chalk.rgb(128, 128, 128).bold

help =
  c.black "[  docs] #{pJ.homepage}"

# -------------------------------------------------------------------------------------------------------

pe = (new prettyError!)

pe.skipNodeFiles!

pe.filterParsedError (Error) ->

  Error._trace = R.drop 6,Error._trace

  Error

pe.skip (traceLine,lineNumber) ->

  if traceLine.dir is "internal/modules/cjs" then return true

  return false


pe.appendStyle do
  "pretty-error > header > title > kind":(display: "none")
  "pretty-error > header > colon":(display: "none")
  "pretty-error > header > message":(display:"none")

# -  - - - - - - - - - - - - - - - - - - - - - - - - --  - - - - - - - - - - - - - - - - - - - - - - - - -


pkgname = pJ.name

show_stack = ->

  l help

  E = pe.render new Error!

  l E

printE.fail = (filename) -> !->

  l do
    "[TEST ERROR] originating from module"
    "[#{pkgname}]"

    "\n\n- 'npm test' failed at #{filename}:"

  process.exitCode = 1


printE.log = (path,data) ->

  str = ""

  for [fname,[lens]],I in data.fns

    str += c.ok '- ' + fname

    switch fname
    | \ar,\arn,\arwh,\arwhn,\arnwhn =>

      str += c.warn ' [ ' + (lens.join ' ') + ' ]'

    if (I < (data.fns.length - 1))

      str += '\n'

  str += "\n-----\n"

  str +=  c.ok 'def :'

  if data.def
    str +=  c.ok ' [function]'
  else
    str += c.warn ' undefined'

  str

gench = R.pipe do
  R.map (x) -> x + "(~)"
  R.join '.'
  (x) -> c.ok x

printE.api_not_defined = (str,attr)->

  l c.er "[#{pkgname}][api.error]"

  l do
    '\n'
    (gench str) + c.er ('.' + attr)

  l do
    c.warn """

    #{c.er('.' + attr)} is not defined within the module.

    """

  show_stack!


printE.path_too_long = (str,attr) !->

  l c.er "[#{pkgname}][api.error] path is too long"

  l do
    '\n'
    (gench str) + c.er('.' + (attr.join '.') + '(~)')
    '\n'

  show_stack!

printE.def_is_defined = (str) !->

  l c.er """
    [#{pkgname}][api.error]
    """

  l do
    '\n'
    (gench str) + (c.er '.def(~)')
    '\n'

  l c.warn "default function can't be defined more than once.\n"


  show_stack!

printE.all_match_fail = !->

  l c.er """
    [#{pkgname}][pattern.matching.error] unable to match arguments
    """

  l do
    c.warn """
    \n - direct call only matches arguments with following acceptable types :

        (function)------(maps to)----> .def

        (number,function)------------> .args

        (function,function)----------> .when

        (number,function,function)---> .args_when

      """

  show_stack!


get_full_str = (fname) ->

  full_name = switch fname
  | \wh     => \when
  | \whn    => \when_not
  | \ar     => \arg
  | \arn    => \arg_not
  | \arwh   => \arg_when
  | \arwhn  => \arg_when_not
  | \arnwhn => \arg_not_when_not
  | \def    => \default

  full_name

StrArgLen = (info,type)->

  data = switch type
  | \f   => [1,'(function)']
  | \nf  => [2,'(number|[num...],function)']
  | \ff  => [2,'(function,function)']
  | \nff => [3,'(number|[num...],function,function)']

  switch info
  | \many_args =>
    [
      "too many arguments"
      c.er "~"
      "only #{data[0]} argument #{data[1]} accepted."
    ]
  | \few_args  =>
    [
      "too few arguments"
      c.er "~"
      "requires #{data[0]} arguments #{data[1]}."
    ]




StrEType = (eType) ->

  [type,info] = eType.split "."

  switch info
  | \many_args,\few_args => return StrArgLen info,type

  parts = switch type
  | \f =>
    switch info
    | \fun =>
      [
        c.ok('(') + c.er('function') + c.ok(')')
        c.er('fun')
      ]

  | \nf =>
    switch info
    | \num =>
      [
        (c.ok("(") + c.er('number|array') + c.ok(',function') + c.ok(')'))
        c.er('num|array') + c.ok(',fun')
      ]
    | \fun =>
      [
        (c.ok('(number,') + c.er('function') + c.ok(')'))
        c.ok('num,') + c.er('fun')
      ]
    | \array =>
      [
        (c.ok("(") + c.er('[num..]') + c.ok(',function') + c.ok(')'))
        c.er('[num..]') + c.ok(',fun')
      ]
  | \ff =>
    switch info
    | \first =>
      [
        c.ok('(') + c.er('function') + c.ok(',function') + c.ok(')')
        c.er('fun') + c.ok(',fun')
      ]
    | \second =>
      [
        c.ok('(') + c.ok('function,') + c.er('function') + c.ok(')')
        c.ok('fun,') + c.er('fun')
      ]
  | \nff =>
    switch info
    | \num =>
      [
        c.ok('(') + c.er('number|array') + c.ok(',function,function') + c.ok(')')
        c.er('num|arr') + c.ok(',fun,fun')
      ]
    | \array =>
      [
        c.ok('(') + c.er('[num..]') + c.ok(',function,function') + c.ok(')')
        c.er('[num..]') + c.ok(',fun,fun')
      ]
    | \first =>
      [
        c.ok('(') + c.ok('array/number,') + c.er("function") + c.ok(",function)")
        c.ok('num|arr') + c.er("fun") + c.ok(',fun')
      ]
    | \second =>
      [
        c.ok("(num|arr,function,") + c.er("function") + c.ok(")")
        c.ok('num|arr,fun,') + c.ok('fun')
      ]

  parts.push 'One of the argument cannot be used by the function'
  parts

printE.typeError = (fname,eType,str) ->

  [long,short,type] = StrEType eType

  l c.er """
    [#{pkgname}][typeError] #{long}
    """

  oname = get_full_str fname

  ePart = c.warn('.' + oname) + c.warn("(") + short + c.warn(")") + c.warn(" <-- error here")

  l do
    '\n'
    (gench str) + ePart
    '\n'
  l ((c.black type) + "\n")

  show_stack!


printE.route = (str,Er) !->

  [__,outerE] = Er

  switch outerE
  | \path =>

    [_,__,eName,attr] = Er

    printE[eName] str,attr

  | \input =>

    [_,__,fname,eType] = Er

    printE.typeError fname,eType,str



module.exports = reg.printE

