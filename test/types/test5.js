var reg, ref$, z, noops, print_fail, be, p, T, F, V, ret;
reg = require("../dist/registry");
ref$ = reg.com, z = ref$.z, noops = ref$.noops, print_fail = ref$.print_fail;
be = require("../dist/main");
p = print_fail("test/test5.js");
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