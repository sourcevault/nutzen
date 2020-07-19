# --------------------------------------------------------------------------------------

js-render     = require 'json-stringify-pretty-compact'

R             = require "ramda"

SI            = require "seamless-immutable"

reg           = require "./registry"

# --------------------------------------------------------------------------------------

l = console.log

z = l

noop = !->

j = (json) !-> l js-render json


main =
  j                   : j
  z                   : z
  R                   : R
  l                   : l
  SI                  : SI
  reg                 : reg
  noop                : noop

module.exports = main
