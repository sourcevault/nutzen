var com;
com = require("./common");
com.binapi = require("./binapi");
com.homepage = 'https://github.com/sourcevault/hoplon#readme.md';
com.common_symbols = {};
com.common_symbols.htypes = Symbol('hoplon.types');
com.version = '1.0.1';
com = Object.freeze(com);
module.exports = com;