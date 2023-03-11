var pkg, utils, types, z, l, R, j, print_fail, be, p, T, F, V, von;
pkg = require('../../dist/types/main');
utils = pkg.utils, types = pkg.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
p = print_fail("test/types/test5.js");
T = function(x){
  return true;
};
F = function(x){
  return [false, 'foobar'];
};
V = be.arr.map(be.str).or(be.num).or(be.obj).and(F);
von = V.auth([1, 2]);
z(von);