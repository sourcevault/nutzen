{l} = require "./common"

reg = require "./registry"

printE = reg.printE

packageJ = reg.packageJ

reg.printE.fail = (filename) -> !->

  l do
    "[TEST ERROR] originating from module"
    "[#{packageJ.name}]"

    "\n\n- 'npm test' failed at #{filename}:"

  process.exitCode = 1


module.exports = reg.printE

