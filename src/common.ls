# --------------------------------------------------------------------------------------

js-render     = require 'json-stringify-pretty-compact'

R             = require "ramda"

chalk         = require "chalk"

SI            = require "seamless-immutable"

reg           = require "./registry"

binapi        = require "binapi"

sim           = require "seamless-immutable-mergers"

pretty-error  = require "pretty-error"

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
  pretty-error        : pretty-error
  sim                 : sim
  reg                 : reg
  noop                : noop
  binapi              : binapi
  chalk               : chalk

module.exports = main

