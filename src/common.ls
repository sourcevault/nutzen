# --------------------------------------------------------------------------------------

R             = require "ramda"

chalk         = require "chalk"

binapi        = require "binapi"

pretty-error  = require "pretty-error"

# --------------------------------------------------------------------------------------

l = console.log

z = l

noop = !->

#--------------------------------------------------------------------------------------

if (typeof window is "undefined") and (typeof module is "object")

  util = require "util"

  util_inspect_custom = util.inspect.custom


else

  util_inspect_custom = Symbol.for "nodejs.util.inspect.custom"

#--------------------------------------------------------------------------------------


main =
  z             : z
  R             : R
  l             : l
  noop          : noop
  chalk         : chalk
  binapi        : binapi
  pretty-error  : pretty-error
  uic           : util_inspect_custom


module.exports = main
