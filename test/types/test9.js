var pkg, utils, types, z, l, R, j, print_fail, be, S, p, V, von, s, V1;
pkg = require('../../dist/types/main');
utils = pkg.utils, types = pkg.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
S = JSON.stringify;
p = print_fail("test/types/test9.js");
V = be.arr.err(['hello world']).err(function(msg){
  return be.flatro(msg);
});
von = V.auth(null);
s = S(von.message[0][1]);
if (s !== '["hello world"]') {
  p(1);
}
V1 = be.arr.err([':me', 'frostbite']).err(be.flatro);
von = V1.auth(1);
s = S(von.message);
if (s !== '[[":me","frostbite"]]') {
  p(2);
}