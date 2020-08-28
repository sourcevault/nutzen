
com = require "./common"

reg = {}

  ..packageJ   = {}
    ..name     = \hoplon
    ..homepage = \https://github.com/sourcevault/hoplon#readme.md

  ..com = com

  ..already_created = new Set!

  ..modflag = Symbol "modflag"

  ..print = {}
    ..fail = null
    ..route = null


  ..betterTypeof = null

  ..verify = {}

  ..main = {}


module.exports = reg

