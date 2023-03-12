var com, z, l, R, j, zj, print_fail, be, p, T, F, V, von;
com = require('../../dist/utils/main');
z = com.z, l = com.l, R = com.R, j = com.j, zj = com.zj, print_fail = com.print_fail;
be = require('../../dist/types/main');
p = print_fail("test/types/test5.js");
T = function(x){
  return true;
};
F = function(x){
  return [false, 'foobar'];
};
V = be.arr.map(be.str.err([':a', 'not_string'])).or(be.str).or(be.obj).and(F);
von = V.auth([1, 2]);
z(von);