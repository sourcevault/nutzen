var pkg, internal, types, z, l, R, j, print_fail, be, p, T, F, V, von, as;
pkg = require('../../dist/types/main');
internal = pkg.internal, types = pkg.types;
z = internal.z, l = internal.l, R = internal.R, j = internal.j, print_fail = internal.print_fail;
be = types;
p = print_fail("test/types/test6.js");
T = function(x){
  return true;
};
F = function(x){
  return [false, 'foobar'];
};
V = be.restricted([0, 1]);
von = V.auth(['a', 'b', 'c']);
as = JSON.stringify(von.message);
if (!(as === '[":res",[0,1]]')) {
  p(".restricted message is not accurate.");
}
as = JSON.stringify(von.path);
if (!(as === '["2"]')) {
  p(".restricted path is not accurate.");
}