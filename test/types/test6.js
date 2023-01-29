var ref$, utils, types, z, l, R, j, print_fail, be, p, T, F, V, ret;
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
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