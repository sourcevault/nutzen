var com, z, l, R, j, zj, print_fail, be, p, T, F, V, ret;
com = require('../../dist/utils/main').com;
z = com.z, l = com.l, R = com.R, j = com.j, zj = com.zj, print_fail = com.print_fail;
be = require('../../dist/types/main');
p = print_fail("test/types/test6.js");
T = function(x){
  return true;
};
F = function(x){
  return [false, 'foobar'];
};
V = be.restricted([0, 1]);
ret = V.auth(['a', 'b', 'c']);
if (!(ret.message[0] === ':res')) {
  p(".restricted message is not accurate.");
}