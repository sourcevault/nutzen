var pkg, internal, types, z, l, R, j, print_fail, be, S, p, V, von, s, V1;
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types;
z = internal.z, l = internal.l, R = internal.R, j = internal.j, print_fail = internal.print_fail;
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