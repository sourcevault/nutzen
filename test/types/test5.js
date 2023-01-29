var ref$, utils, types, z, l, R, j, print_fail, be, p, T, F, V, ret;
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
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