# --------------------------------------------------------------------------------------

R             = require "ramda"

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

c = {}
  ..ok    = (txt) -> "\x1B[38;5;2m#{txt}\x1B[39m"
  ..er    = (txt) -> "\x1B[38;5;3m#{txt}\x1B[39m"
  ..warn  = (txt) -> "\x1B[38;5;11m#{txt}\x1B[39m"
  ..err   = (txt) -> "\x1B[38;5;13m#{txt}\x1B[39m"
  ..black = (txt) -> "\x1B[38;5;8m#{txt}\x1B[39m"

main =
  z             : z
  R             : R
  l             : l
  c             : c
  noop          : noop
  binapi        : binapi
  pretty-error  : pretty-error
  uic           : util_inspect_custom


module.exports = main
