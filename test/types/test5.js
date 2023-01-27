var com, z, l, R, j, zj, print_fail, be, p, T, F, V, ret;
com = require('../../dist/utils/main').com;
z = com.z, l = com.l, R = com.R, j = com.j, zj = com.zj, print_fail = com.print_fail;
be = require('../../dist/types/main');
p = print_fail("test/types/test5.js");
T = function(x){
  return true;
};
F = function(x){
  return [false, 'foobar'];
};
V = be.arr.map(be.str).or(be.str).or(be.obj).and(F);
ret = V.auth(null);
if (!(ret.message[0] === "not array")) {
  p();
}