var ref$, com, print, z, l, R, j, deep_freeze, uic, loopError, noop, oxo, int, custom, define, cache, be;
ref$ = require('./print.common'), com = ref$.com, print = ref$.print;
z = com.z, l = com.l, R = com.R, j = com.j, deep_freeze = com.deep_freeze, uic = com.uic, loopError = com.loopError, noop = com.noop;
oxo = require('../guard/main');
int = require('./internal');
custom = int.custom, define = int.define, cache = int.cache;
be = custom;
be = deep_freeze(be);
module.exports = be;