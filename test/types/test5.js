var pkg, utils, types, z, l, R, j, print_fail, be, p, T, F, V, von, bvon, msg;
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
V = be.arr.map(be.str).or(be.num.or(be.str)).or(be.obj).and(F);
von = V.auth(null);
if (!(von.message[0][0] === "not array")) {
  p(1);
}
bvon = be.flatro(von.message);
msg = bvon[0][1][0];
if (msg !== "not array") {
  p(".flatro algo has problem");
}