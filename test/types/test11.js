var pkg, utils, types, z, l, R, j, print_fail, be, N, V;
pkg = require('../../dist/types/main');
utils = pkg.utils, types = pkg.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
N = be.num.tap(function(x, index, accum){
  return accum.push("a:" + x);
});
V = {};
V[0] = be.arr.forEach([0, 1, 1], N);