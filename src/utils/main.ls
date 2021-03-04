
com                       = require "./common"

com.binapi                = require "./binapi"

com.homepage              = \https://github.com/sourcevault/hoplon#readme.md

com.common_symbols        = {}

com.common_symbols.htypes = Symbol \hoplon.types

com                       = com.deep_freeze com

module.exports = com