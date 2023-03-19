var pkg, utils, types, z, l, R, j, print_fail, be, p, T, F, V, von, as;
pkg = require('../../dist/types/main');
utils = pkg.utils, types = pkg.types;
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
von = V.auth(['a', 'b', 'c']);
as = JSON.stringify(von.message);
if (!(as === '[":res",[0,1]]')) {
  p(".restricted message is not accurate.");
}
as = JSON.stringify(von.path);
if (!(as === '["2"]')) {
  p(".restricted path is not accurate.");
}